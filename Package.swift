// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "velo-today-ios",
    platforms: [.iOS(.v15)],
    products: [
      .library(name: "ApiClient", targets: ["ApiClient"]),
      .library(name: "DetailsFeature", targets: ["DetailsFeature"]),
      .library(name: "FavoriteFeature", targets: ["FavoriteFeature"]),
      .library(name: "Models", targets: ["Models"]),
      .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
      .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"])
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.40.2"),
    ],
    targets: [
      .target(name: "ApiClient"),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
        ]
      ),
      .target(
        name: "FavoriteFeature",
        dependencies: [
          "Models",
          "DetailsFeature"
        ]
      ),
      .target(name: "Models"),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models"
        ]
      ),
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      )
    ]
)
