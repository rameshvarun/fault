#!/usr/bin/env bash
adb push game/ /sdcard/
adb shell am start -n "net.varunramesh.fault/.FaultActivity" -d file:///storage/emulated/0/game/main.lua
adb logcat | grep net.varunramesh.fault
