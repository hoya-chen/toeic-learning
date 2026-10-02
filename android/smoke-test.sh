#!/bin/sh
# Installs the (debug) APK on a running emulator, taps through the first learning steps with
# real touches, and checks what the page shows through Chrome DevTools.
set -e
APK="$1"
PKG=io.github.hoyachen.toeic
js() { node android/cdp.mjs "$1" 2>/dev/null || true; }
fail() {
  echo "FAILED: $1"
  adb exec-out screencap -p > screen-fail.png || true
  echo "--- page text"; js "document.body.innerText.slice(0,1500)"
  echo "--- log"; adb logcat -d | grep -E "FATAL|AndroidRuntime|chromium.*CONSOLE|$PKG" | tail -40
  exit 1
}
# Waits until a page expression returns the expected value.
expect() { i=0; until [ "$(js "$1")" = "$2" ]; do i=$((i+1)); [ $i -gt 20 ] && fail "$1 should be $2 (is $(js "$1"))"; sleep 1; done; echo "ok: $1 = $2"; }
# Where the WebView sits on screen, in pixels, from the UI tree.
webview_origin() {
  adb shell uiautomator dump /sdcard/ui.xml >/dev/null; adb pull /sdcard/ui.xml ui.xml >/dev/null
  grep -o '<node [^>]*class="android.webkit.WebView"[^>]*>' ui.xml | head -1 | grep -o 'bounds="\[[0-9]*,[0-9]*\]' | grep -oE '[0-9]+' | tr '\n' ' '
}
# Screen point at a fraction of an element's box: point <selector> <fx> <fy>
point() {
  r=$(js "(()=>{const e=document.querySelector('$1');if(!e)return '';e.scrollIntoView({block:'nearest'});const b=e.getBoundingClientRect(),d=devicePixelRatio;return Math.round((b.left+b.width*$2)*d)+' '+Math.round((b.top+b.height*$3)*d)})()")
  [ -n "$r" ] || fail "no element $1"
  set -- $r $ORIGIN; echo "$(( $1+$3 )) $(( $2+$4 ))"
}
tap() { xy=$(point "$1" 0.5 0.5); echo "tap $1 at $xy"; adb shell input tap $xy; sleep 1; }

adb install -r "$APK"
adb shell input keyevent 82
adb logcat -c
adb shell am start -W -n $PKG/.MainActivity
sleep 3
PID=$(adb shell pidof $PKG | tr -d '\r')
adb forward tcp:9222 localabstract:webview_devtools_remote_$PID
ORIGIN=$(webview_origin); [ -n "$ORIGIN" ] || fail "WebView not on screen"; echo "WebView at $ORIGIN"
expect "!!window.AndroidApp" true

# Onboarding, then the Today screen.
expect "!!document.querySelector('#obgo')" true
tap "#obgo"
expect "!!document.querySelector('.task[data-step=learn]')" true

# Learn cards: the footer button and a right swipe each count a card as known.
tap ".task[data-step=learn]"
expect "document.querySelector('#scnt').textContent" "1 / 25"
tap '[data-r="1"]'
expect "document.querySelector('#scnt').textContent" "2 / 25"
set -- $(point "#flash .fword" 0.1 0.5)
echo "swipe card right from $1 $2"
js "window.__ev=[];['pointerdown','pointermove','pointerup','pointercancel','touchstart','touchend','touchcancel'].forEach(t=>document.addEventListener(t,e=>{if(__ev.length<40)__ev.push(t+':'+Math.round(e.clientX!=null?e.clientX:(e.changedTouches[0]||{}).clientX)+':'+(e.target.className||e.target.tagName))},true));1" >/dev/null
adb shell input swipe $1 $2 $(( $1+700 )) $2 300
sleep 1
echo "page events: $(js "__ev.join(' ')")"
expect "document.querySelector('#scnt').textContent" "3 / 25"
expect "Object.keys(JSON.parse(localStorage.getItem('toeic-srs')||'{}')).length" 2

# Back closes the card sheet, then a second back leaves the app.
adb shell input keyevent 4
expect "document.querySelector('#sheet').hidden" true
expect "document.querySelector('.task[data-step=learn]').textContent.includes('2 / 25')" true
adb shell input keyevent 4
sleep 2
adb shell dumpsys activity activities | grep -E "mResumedActivity|ResumedActivity:" | grep -q $PKG && fail "app still in front after second back"
echo "ok: second back leaves the app"

adb logcat -d | grep -E "chromium.*CONSOLE.*(Uncaught|Error)" && fail "page errors" || true
echo "smoke test passed"
