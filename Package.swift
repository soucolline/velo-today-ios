// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "velo-today-ios",
    platforms: [.iOS(.v15)],
    products: [
      .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
//      .library(name: "Models", targets: ["Models"]),
//      .library(name: "UVClient", targets: ["UVClient"])
    ],
    targets: [
      .target(name: "UserDefaultsClient")
//      .target(
//        name: "AppFeature",
//        dependencies: [
//          "Models",
//          "UVClient",
//          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
//          .product(name: "ComposableCoreLocation", package: "composable-core-location")
//        ]
//      ),
//      .target(name: "Models"),
//      .target(
//        name: "UVClient",
//        dependencies: [
//          "Models",
//          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
//        ]
//      ),
//      .testTarget(
//        name: "AppFeatureTests",
//        dependencies: [
//          "AppFeature",
//          "Models",
//          "UVClient",
//          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
//        ]
//      ),
//      .testTarget(
//        name: "ModelsTests",
//        dependencies: [
//          "Models"
//        ]
//      )
    ]
)
