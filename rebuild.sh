#!/bin/bash
cd cboard
NODE_OPTIONS="--max-old-space-size=4096 --openssl-legacy-provider" npm run build
cd ..
rm -rf www/*
cp -r cboard/build/* www/
cordova prepare android
echo "Build complete! Open Android Studio and run the app." 