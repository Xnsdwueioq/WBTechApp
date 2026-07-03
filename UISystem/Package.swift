// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UISystem",
  platforms: [.iOS(.v18)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "UISystem",
      targets: ["UISystem"]
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "UISystem",
      resources: [
        .process("DSAssets.xcassets")
      ],
      swiftSettings: [
        .enableUpcomingFeature("ApproachableConcurrency"),
      ]
    ),
    .testTarget(
      name: "UISystemTests",
      dependencies: ["UISystem"],
      swiftSettings: [
        .enableUpcomingFeature("ApproachableConcurrency"),
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
