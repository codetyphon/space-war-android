cd src
zip -9 -r ../decoded/assets/game.love .
cd ..
java -jar ./tools/apktool_2.5.0.jar  b -o ./build/debug.apk decoded
java -jar ./tools/uber-apk-signer-1.2.1.jar --apks ./build/debug.apk