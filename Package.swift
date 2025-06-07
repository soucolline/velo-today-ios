// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let sharing: Target.Dependency = .product(name: "Sharing", package: "swift-sharing")
let perception: Target.Dependency = .product(name: "Perception", package: "swift-perception")
let navigation: Target.Dependency = .product(name: "UIKitNavigation", package: "swift-navigation")

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
      .package(url: "https://github.com/pointfreeco/swift-sharing", exact: "2.5.2"),
      .package(url: "https://github.com/pointfreeco/swift-perception", exact: "1.6.0"),
      .package(url: "https://github.com/pointfreeco/swift-navigation", exact: "2.3.0")
    ],
    targets: [
      .target(
        name: "ApiClient",
        dependencies: [
          "Models",
          sharing,
          perception
        ]
      ),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          sharing,
          perception,
        ]
      ),
      .testTarget(
        name: "DetailsFeatureTests",
        dependencies: [
          "DetailsFeature",
          "UserDefaultsClient",
          "Models",
          sharing,
          perception,
        ]
      ),
      .target(
        name: "FavoriteFeature",
        dependencies: [
          "ApiClient",
          "DetailsFeature",
          "Models",
          "UserDefaultsClient",
          sharing,
          perception,
        ]
      ),
      .testTarget(
        name: "FavoriteFeatureTests",
        dependencies: [
          "ApiClient",
          "FavoriteFeature",
          "Models",
          "DetailsFeature",
          "UserDefaultsClient"
        ]
      ),
      .target(
        name: "MapFeature",
        dependencies: [
          "ApiClient",
          "Models",
          "DetailsFeature",
          sharing,
          perception,
          navigation
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
        ]
      ),
      .target(name: "Models"),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
        ]
      ),
      .testTarget(
        name: "SettingsFeatureTests",
        dependencies: [
          "SettingsFeature",
          "Models",
          "UserDefaultsClient",
        ]
      ),
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          sharing,
          perception
        ]
      )
    ]
)
