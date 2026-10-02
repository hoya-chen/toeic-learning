#!/bin/sh
# Installs the APK on a running emulator and walks the first screens through the UI tree.
set -e
APK="$1"
dump() { adb shell uiautomator dump /sdcard/ui.xml >/dev/null; adb pull /sdcard/ui.xml ui.xml >/dev/null; }
has() { dump; grep -q "\(text\|content-desc\)=\"$1" ui.xml; }
wait_for() { i=0; until has "$1"; do i=$((i+1)); [ $i -gt 20 ] && { echo "NOT FOUND: $1"; grep -o '\(text\|content-desc\)="[^"]\+"' ui.xml | head -40; exit 1; }; sleep 2; done; echo "found: $1"; }
tap() { wait_for "$1"; b=$(grep -o "<node [^>]*\(text\|content-desc\)=\"$1[^>]*>" ui.xml | head -1 | grep -o 'bounds="[^"]*"' | grep -oE '[0-9]+' | tr '\n' ' '); set -- $b; adb shell input tap $(( ($1+$3)/2 )) $(( ($2+$4)/2 )); sleep 2; }

adb install -r "$APK"
adb shell am start -n io.github.hoyachen.toeic/.MainActivity
tap "開始學習"
wait_for "開始今日任務"
tap "開始今日任務"
wait_for "記得了"
tap "記得了"
wait_for "2 / "
adb shell input keyevent 4
sleep 2
wait_for "開始今日任務"
adb logcat -d | grep -E "chromium.*(Uncaught|Error)" && { echo "page errors found"; exit 1; } || true
echo "smoke test passed"
