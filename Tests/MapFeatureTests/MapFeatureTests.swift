import ApiClient
import ComposableArchitecture
@testable import MapFeature
import Models
import Testing
import TestSupport

@MainActor
struct MapFeatureTests {
  @Test
  func initialLoadFetchesOnceAndCentersOnUser() async {
    let station = makeStation("1001")
    let location = MapLocation(latitude: 48.85, longitude: 2.35)
    let clock = TestClock()
    let store = TestStore(initialState: mapState()) {
      MapFeature()
    } withDependencies: {
      $0.apiClient = StubAPI { [station] }
      $0.mapLocation = {
        try? await clock.sleep(for: .seconds(1))
        return location
      }
    }

    await store.send(.onAppear) {
      $0.hasStarted = true
      $0.isLoading = true
    }
    await store.receive(\.stationsResponse.success) {
      $0.isLoading = false
      $0.$stations.withLock { $0 = [station] }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(\.locationResponse) {
      $0.center = location
    }
    await store.send(.onAppear)
    await store.finish()
  }

  @Test
  func failedReloadKeepsPinsAndCanBeRetried() async {
    let existing = makeStation("1001")
    let replacement = makeStation("1002")
    let attempts = LockIsolated(0)
    let store = TestStore(initialState: mapState(stations: [existing])) {
      MapFeature()
    } withDependencies: {
      $0.apiClient = StubAPI {
        let attempt = attempts.withValue { $0 += 1; return $0 }
        if attempt == 1 { throw FetchError.offline }
        return [replacement]
      }
    }

    await store.send(.reloadButtonTapped) { $0.isLoading = true }
    await store.receive(\.stationsResponse.failure) {
      $0.isLoading = false
      $0.alert = AlertState {
        TextState("Erreur")
      } actions: {
        ButtonState { TextState("OK") }
      } message: {
        TextState("Impossible de charger les données de certaines stations")
      }
    }
    expectNoDifference(store.state.stations, [existing])
    await store.send(.alert(.dismiss)) { $0.alert = nil }
    await store.send(.reloadButtonTapped) { $0.isLoading = true }
    await store.receive(\.stationsResponse.success) {
      $0.isLoading = false
      $0.$stations.withLock { $0 = [replacement] }
    }
  }

  @Test
  func secondReloadCancelsTheFirst() async {
    let clock = TestClock()
    let station = makeStation("1001")
    let attempts = LockIsolated(0)
    let store = TestStore(initialState: mapState()) {
      MapFeature()
    } withDependencies: {
      $0.apiClient = StubAPI {
        let attempt = attempts.withValue { $0 += 1; return $0 }
        if attempt == 1 { try await clock.sleep(for: .seconds(10)) }
        return [station]
      }
    }

    await store.send(.reloadButtonTapped) { $0.isLoading = true }
    await store.send(.reloadButtonTapped)
    await store.receive(\.stationsResponse.success) {
      $0.isLoading = false
      $0.$stations.withLock { $0 = [station] }
    }
    await clock.advance(by: .seconds(10))
    await store.finish()
  }

  @Test
  func missingLocationKeepsParisAsFallback() async {
    let store = TestStore(initialState: mapState()) { MapFeature() }
    await store.send(.locationResponse(nil))
    expectNoDifference(store.state.center, MapLocation(latitude: 48.866667, longitude: 2.333333))
  }

  private func mapState(stations: [Station] = []) -> MapFeature.State {
    MapFeature.State(
      favoriteCodes: Shared(value: []),
      mapStyle: SharedReader(Shared(value: "normalStyle")),
      stations: Shared(value: stations)
    )
  }
}
