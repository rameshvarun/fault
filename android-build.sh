#!/usr/bin/env bash

svgexport media/icon.svg android/res/drawable-mdpi/love.png 48:48
svgexport media/icon.svg android/res/drawable-hdpi/love.png 72:72

svgexport media/icon.svg android/res/drawable-xhdpi/love.png 96:96
svgexport media/icon.svg android/res/drawable-xxhdpi/love.png 144:144
svgexport media/icon.svg android/res/drawable-xxxhdpi/love.png 192:192

mkdir -p android/assets
cd game
zip -r ../android/assets/game.love *
cd ../android
ant debug install
