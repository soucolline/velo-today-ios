// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let sharing: Target.Dependency = .product(name: "Sharing", package: "swift-sharing")
let perception: Target.Dependency = .product(name: "Perception", package: "swift-perception")
let navigation: Target.Dependency = .product(name: "UIKitNavigation", package: "swift-navigation")

let package = Package(
    name: "velo-today-ios",
    platforms: [.iOS(.v16)],
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
      .package(url: "https://github.com/pointfreeco/swift-navigation", exact: "2.3.1")
    ],
    targets: [
      .target(
        name: "ApiClient",
        dependencies: [
          "Models",
          sharing,
          perception
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
        ]
      ),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          sharing,
          perception,
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
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
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
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
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
        ]
      ),
      .target(
        name: "Models",
        swiftSettings: [
          .defaultIsolation(MainActor.self)
        ]
      ),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
        ]
      ),
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          sharing,
          perception
        ],
        swiftSettings: [
          .defaultIsolation(MainActor.self)
        ]
      ),
      .testTarget(
        name: "AppTests"
      )
    ]
)
