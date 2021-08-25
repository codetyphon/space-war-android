mkdir build
java -jar ./tools/apktool_2.5.0.jar  d -s -o decoded ./tools/love-11.3-android-embed.apk
mkdir ./decoded/assets
zip -9 -r ./decoded/assets/game.love ./src
rm ./decoded/AndroidManifest.xml
cp ./AndroidManifest.xml ./decoded/
java -jar ./tools/apktool_2.5.0.jar  b -o ./build/debug.apk decoded
java -jar ./tools/uber-apk-signer-1.2.1.jar --apks ./build/debug.apk