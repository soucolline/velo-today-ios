# velo-today-ios

An iOS app for finding Vélib’ stations in Paris, checking bike and dock availability, and saving favorite stations.

Open `app/velib-map.xcodeproj` in Xcode and select the `velib-map` scheme and an iOS simulator. Build and run the app, or use Product → Test to run all feature test targets.

The map, favorites, and settings each have their own Composable Architecture store. SwiftUI handles tab selection, and Swift Sharing keeps the station catalog, favorite codes, and map style in sync across features. Favorite codes and map style use the same UserDefaults keys as previous versions. Tests use controlled network, location, and clock dependencies so they do not require the live Vélib’ service.
