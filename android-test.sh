#!/usr/bin/env bash
adb push game/ /sdcard/
adb shell am start -n "org.love2d.android/.GameActivity" -d file:///storage/emulated/0/game/main.lua
adb logcat | grep org.love2d.android
