// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let sharing: Target.Dependency = .product(name: "Sharing", package: "swift-sharing")
let architecture: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let dependencies: Target.Dependency = .product(name: "Dependencies", package: "swift-dependencies")

let package = Package(
    name: "velo-today-ios",
    platforms: [.iOS(.v18)],
    products: [
      .library(name: "AppFeature", targets: ["AppFeature"])
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.26.2"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.17.2"),
      .package(url: "https://github.com/pointfreeco/swift-sharing", exact: "2.10.1")
    ],
    targets: [
      .target(
        name: "AppFeature",
        dependencies: ["FavoriteFeature", "MapFeature", "Models", "SettingsFeature", "UserDefaultsClient", architecture]
      ),
      .target(
        name: "ApiClient",
        dependencies: [
          "Models",
          dependencies
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "DetailsFeature",
        dependencies: [
          "Models",
          architecture
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "FavoriteFeature",
        dependencies: [
          "ApiClient",
          "DetailsFeature",
          "Models",
          architecture
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "MapFeature",
        dependencies: [
          "ApiClient",
          "Models",
          "DetailsFeature",
          architecture
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "Models",
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "SettingsFeature",
        dependencies: [
          "Models",
          "UserDefaultsClient",
          architecture
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          dependencies, sharing
        ],
        swiftSettings: [
          .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
          .enableUpcomingFeature("InferIsolatedConformances")
        ]
      ),
      .target(
        name: "TestSupport",
        dependencies: ["ApiClient", "Models"],
        path: "Tests/TestSupport"
      ),
      .testTarget(
        name: "AppFeatureTests",
        dependencies: ["AppFeature", "TestSupport"]
      ),
      .testTarget(
        name: "DetailsFeatureTests",
        dependencies: ["DetailsFeature", "TestSupport"]
      ),
      .testTarget(
        name: "FavoriteFeatureTests",
        dependencies: ["FavoriteFeature", "TestSupport"]
      ),
      .testTarget(
        name: "MapFeatureTests",
        dependencies: ["MapFeature", "TestSupport"]
      ),
      .testTarget(
        name: "SettingsFeatureTests",
        dependencies: ["SettingsFeature"]
      )
    ]
)
