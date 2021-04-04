#!/usr/bin/env bash
mkdir -p build
rm -f build/game.love
cd game
zip -r ../build/game.love *
