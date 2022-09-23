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
      .library(name: "MapFeature", targets: ["MapFeature"]),
      .library(name: "Models", targets: ["Models"]),
      .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
      .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"])
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.40.2"),
    ],
    targets: [
      .target(
        name: "ApiClient",
        dependencies: [
          "Models",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .testTarget(
        name: "DetailsFeatureTests",
        dependencies: [
          "DetailsFeature",
          "UserDefaultsClient",
          "Models",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "FavoriteFeature",
        dependencies: [
          "Models",
          "DetailsFeature",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .testTarget(
        name: "FavoriteFeatureTests",
        dependencies: [
          "ApiClient",
          "FavoriteFeature",
          "Models",
          "DetailsFeature",
          "UserDefaultsClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "MapFeature",
        dependencies: [
          "Models",
          "DetailsFeature",
         .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .testTarget(
        name: "MapFeatureTests",
        dependencies: [
          "ApiClient",
          "MapFeature",
          "Models",
          "DetailsFeature",
          "UserDefaultsClient",
         .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(name: "Models"),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .testTarget(
        name: "SettingsFeatureTests",
        dependencies: [
          "SettingsFeature",
          "Models",
          "UserDefaultsClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
