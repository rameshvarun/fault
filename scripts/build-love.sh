#!/usr/bin/env bash
mkdir -p release
rm -f release/fault.love
cd game
zip -r ../release/fault.love *
