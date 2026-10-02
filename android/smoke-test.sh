#!/bin/sh
# Installs the APK on a running emulator and walks the first screens through the UI tree.
set -e
APK="$1"
dump() { adb shell uiautomator dump /sdcard/ui.xml >/dev/null; adb pull /sdcard/ui.xml ui.xml >/dev/null; grep -q 'package="io.github.hoyachen.toeic"' ui.xml && cp ui.xml app-ui.xml; true; }
has() { dump; grep -q "\(text\|content-desc\)=\"$1" ui.xml; }
fail() { echo "NOT FOUND: $1"; echo "--- screen now"; grep -o '\(text\|content-desc\)="[^"]\+"' ui.xml | head -30; echo "--- last app screen"; [ -f app-ui.xml ] && grep -o '\(text\|content-desc\)="[^"]\+"' app-ui.xml | head -60; echo "--- log"; adb logcat -d | grep -E "FATAL|hoyachen|chromium|lowmemory|Killing|ActivityManager: (Process|Kill|Force)|ActivityTaskManager: (START|Force)" | grep -v Cronet | tail -60; exit 1; }
center() { b=$(grep -o "<node [^>]*\(text\|content-desc\)=\"$1[^>]*>" ui.xml | head -1 | grep -o 'bounds="[^"]*"' | grep -oE '[0-9]+' | tr '\n' ' '); set -- $b; echo "$(( ($1+$3)/2 )) $(( ($2+$4)/2 ))"; }
# The emulator's own launcher sometimes shows "isn't responding"; dismiss it with "Wait".
wait_for() { i=0; until has "$1"; do i=$((i+1)); [ $i -gt 30 ] && fail "$1"; grep -q 'text="Wait"' ui.xml && adb shell input tap $(center "Wait"); sleep 2; done; echo "found: $1"; }
tap() { wait_for "$1"; adb shell input tap $(center "$1"); sleep 2; }

adb install -r "$APK"
adb shell input keyevent 82
adb logcat -c
adb shell am start -W -n io.github.hoyachen.toeic/.MainActivity
tap "開始學習"
wait_for "開始今日任務"
tap "學新字"
wait_for "記得了"
tap "記得了"
wait_for "2 / "
adb shell input keyevent 4
sleep 2
wait_for "開始今日任務"
adb logcat -d | grep -E "chromium.*(Uncaught|Error)" && { echo "page errors found"; exit 1; } || true
echo "smoke test passed"
