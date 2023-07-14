#!bin/sh

NAME="SDKHttpCore"

rm -rf .build
rm -rf build
rm -rf .archive
rm -rf .derivedData
rm -rf $NAME.xcframework
rm -rf *.zip

swift build
swift build -c release

xcodegen

xcodebuild archive \
  -project $NAME.xcodeproj \
  -scheme $NAME \
  -archivePath .archive/ios.xcarchive \
  -derivedDataPath .derivedData \
  -destination "generic/platform=iOS" \
  -sdk iphoneos \
  BUILD_DIR=.build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
  -project $NAME.xcodeproj \
  -scheme $NAME \
  -archivePath .archive/ios-simulator.xcarchive \
  -derivedDataPath .derivedData \
  -destination "generic/platform=iOS simulator" \
  -sdk iphonesimulator \
  BUILD_DIR=.build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
  -framework .archive/ios.xcarchive/Products/Library/Frameworks/$NAME.framework \
  -framework .archive/ios-simulator.xcarchive/Products/Library/Frameworks/$NAME.framework \
  -output $NAME.xcframework