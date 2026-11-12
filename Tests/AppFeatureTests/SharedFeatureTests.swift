import ApiClient
import ComposableArchitecture
import DetailsFeature
@testable import FavoriteFeature
import Foundation
@testable import MapFeature
import Models
@testable import SettingsFeature
import Testing
import TestSupport
import UserDefaultsClient

@MainActor
struct SharedFeatureTests {
  @Test
  func favoriteAddedOnMapCanBeRemovedFromFavorites() async throws {
    let station = makeStation("1001")
    let codes = Shared<[String]>(value: [])
    let stations = Shared<[Station]>(value: [])
    let map = TestStore(initialState: MapFeature.State(
      favoriteCodes: codes,
      mapStyle: SharedReader(Shared(value: "normalStyle")),
      stations: stations
    )) {
      MapFeature()
    } withDependencies: {
      $0.apiClient = StubAPI { [station] }
    }
    let favorites = TestStore(initialState: FavoriteFeature.State(favoriteCodes: codes, stations: stations)) {
      FavoriteFeature()
    }

    await map.send(.reloadButtonTapped) { $0.isLoading = true }
    await map.receive(\.stationsResponse.success) {
      $0.isLoading = false
      $0.$stations.withLock { $0 = [station] }
    }
    #expect(favorites.state.favoriteStations.isEmpty)

    await map.send(.stationPinTapped(station)) {
      $0.details = DetailsFeature.State(station: station, favoriteCodes: codes)
    }
    await map.send(.details(.presented(.favoriteButtonTapped))) {
      $0.$favoriteCodes.withLock { $0 = [station.code] }
    }
    expectNoDifference(favorites.state.favoriteStations, [station])

    await favorites.send(.stationTapped(station)) {
      $0.path.append(DetailsFeature.State(station: station, favoriteCodes: codes))
    }
    let id = try #require(favorites.state.path.ids.last)
    await favorites.send(.path(.element(id: id, action: .favoriteButtonTapped))) {
      $0.$favoriteCodes.withLock { $0 = [] }
    }
    #expect(map.state.details?.isFavoriteStation == false)
    await map.send(.details(.dismiss)) { $0.details = nil }
    await favorites.send(.path(.popFrom(id: id))) { $0.path.removeAll() }
    #expect(favorites.state.showsEmptyView)
  }

  @Test
  func existingPreferencesAreReadAndWrittenUnderTheSameKeys() async throws {
    let suite = "SharedFeatureTests.\(UUID())"
    let defaults = try #require(UserDefaults(suiteName: suite))
    defer { defaults.removePersistentDomain(forName: suite) }
    let station = makeStation("1001")
    defaults.set([station.code], forKey: "favoriteStationsCode")
    defaults.set("hybridStyle", forKey: "mapStyle")
    let codes = AppPreferences.favoriteCodes(store: defaults)
    let style = AppPreferences.mapStyle(store: defaults)
    let map = TestStore(initialState: MapFeature.State(
      favoriteCodes: codes,
      mapStyle: SharedReader(style),
      stations: Shared(value: [])
    )) {
      MapFeature()
    }
    let settings = TestStore(initialState: SettingsFeature.State(mapStyle: style)) {
      SettingsFeature()
    }

    expectNoDifference(map.state.style, .hybrid)
    await settings.send(.pickerSelectionChanged(2)) {
      $0.$mapStyle.withLock { $0 = "satelliteStyle" }
    }
    expectNoDifference(map.state.style, .satellite)
    expectNoDifference(defaults.string(forKey: "mapStyle"), "satelliteStyle")
    await map.send(.stationPinTapped(station)) {
      $0.details = DetailsFeature.State(station: station, favoriteCodes: codes)
    }
    #expect(map.state.details?.isFavoriteStation == true)
    await map.send(.details(.presented(.favoriteButtonTapped))) {
      $0.$favoriteCodes.withLock { $0 = [] }
    }
    expectNoDifference(defaults.stringArray(forKey: "favoriteStationsCode"), [])
    await map.send(.details(.dismiss)) { $0.details = nil }
  }
}
