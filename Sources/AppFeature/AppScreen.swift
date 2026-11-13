import ComposableArchitecture
import FavoriteFeature
import MapFeature
import Models
import SettingsFeature
import SwiftUI
import UserDefaultsClient

public struct AppScreen: View {
  private let favoritesStore: StoreOf<FavoriteFeature>
  private let mapStore: StoreOf<MapFeature>
  private let settingsStore: StoreOf<SettingsFeature>

  public init() {
    let favoriteCodes = AppPreferences.favoriteCodes()
    let mapStyle = AppPreferences.mapStyle()
    let stations = Shared<[Station]>(value: [])

    favoritesStore = Store(initialState: FavoriteFeature.State(
      favoriteCodes: favoriteCodes,
      stations: stations
    )) {
      FavoriteFeature()
    }
    mapStore = Store(initialState: MapFeature.State(
      favoriteCodes: favoriteCodes,
      mapStyle: SharedReader(mapStyle),
      stations: stations
    )) {
      MapFeature()
    }
    settingsStore = Store(initialState: SettingsFeature.State(mapStyle: mapStyle)) {
      SettingsFeature()
    }
  }

  public var body: some View {
    TabView {
      MapScreen(store: mapStore)
        .tabItem { Label("Stations", systemImage: "bicycle.circle.fill") }

      FavoriteListScreen(store: favoritesStore)
        .tabItem { Label("Favoris", systemImage: "star.circle.fill") }

      SettingsScreen(store: settingsStore)
        .tabItem { Label("Réglages", systemImage: "gear.circle.fill") }
    }
  }
}

#Preview {
  AppScreen()
}
