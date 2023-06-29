// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SDKHttpCore",
  platforms: [
    .iOS(.v12),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "SDKHttpCore",
      targets: ["SDKHttpCore"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SDKHttpCore",
      dependencies: [],
      path: "Sources/SDKHttpCore/Lib"
    ),
    .testTarget(
      name: "SDKHttpCoreTests",
      dependencies: ["SDKHttpCore"],
      path: "Sources/Tests"
    )
  ]
)
