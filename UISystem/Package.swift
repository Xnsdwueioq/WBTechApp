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
  dependencies: [
    .package(
      url: "https://github.com/kean/Nuke.git",
      from: "13.2.0"
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "UISystem",
      dependencies: [
        .product(name: "Nuke", package: "Nuke"),
        .product(name: "NukeUI", package: "Nuke")
      ],
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
