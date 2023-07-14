#!bin/sh

NAME="SDKHttpCore"

rm -rf .build
rm -rf build
rm -rf .archive
rm -rf .derivedData
rm -rf $NAME.xcodeproj
rm -rf $NAME.xcframework
rm -rf *.zip
rm -f Info.plist

swift build
swift build -c release
xcodegen

xcodebuild archive \
  -project $NAME.xcodeproj \
  -scheme $NAME \
  -configuration Release \
  -archivePath .archive/ios.xcarchive \
  -derivedDataPath .derivedData \
  -destination generic/platform=iOS \
  -sdk iphoneos \
  DEFINES_MODULE=YES \
  BUILD_DIR=.build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
  -project $NAME.xcodeproj \
  -scheme $NAME \
  -configuration Release \
  -archivePath .archive/ios-simulator.xcarchive \
  -derivedDataPath .derivedData \
  -destination "generic/platform=iOS simulator" \
  -sdk iphonesimulator \
  DEFINES_MODULE=YES \
  BUILD_DIR=.build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
  -framework .archive/ios.xcarchive/Products/Library/Frameworks/$NAME.framework \
  -framework .archive/ios-simulator.xcarchive/Products/Library/Frameworks/$NAME.framework \
  -output $NAME.xcframework

zip -r $NAME.xcframework.zip $NAME.xcframework