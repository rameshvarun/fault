#!/usr/bin/env bash
rm -rf release/web
love-js release/fault.love -c release/web -t Fault
cp platform/web/index.html release/web/
