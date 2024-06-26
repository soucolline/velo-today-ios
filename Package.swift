// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")

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
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.10.2"),
    ],
    targets: [
      .target(
        name: "ApiClient",
        dependencies: [
          "Models",
          tca,
        ]
      ),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          tca,
        ]
      ),
      .testTarget(
        name: "DetailsFeatureTests",
        dependencies: [
          "DetailsFeature",
          "UserDefaultsClient",
          "Models",
          tca,
        ]
      ),
      .target(
        name: "FavoriteFeature",
        dependencies: [
          "ApiClient",
          "DetailsFeature",
          "Models",
          "UserDefaultsClient",
          tca,
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
          "ApiClient",
          "Models",
          "DetailsFeature",
         tca,
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
         tca,
        ]
      ),
      .target(name: "Models"),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          tca,
        ]
      ),
      .testTarget(
        name: "SettingsFeatureTests",
        dependencies: [
          "SettingsFeature",
          "Models",
          "UserDefaultsClient",
          tca,
        ]
      ),
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          tca,
        ]
      )
    ]
)
