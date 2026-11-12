import ApiClient
import ComposableArchitecture
@testable import FavoriteFeature
import Models
import Testing
import TestSupport

@MainActor
struct FavoriteFeatureTests {
  @Test
  func refreshReplacesCatalogAndFiltersToFavoriteCodes() async {
    let saved = makeStation("1001")
    let other = makeStation("1002")
    let store = TestStore(initialState: favoriteState(codes: [saved.code])) {
      FavoriteFeature()
    } withDependencies: {
      $0.apiClient = StubAPI { [saved, other] }
    }

    #expect(store.state.showsEmptyView)
    await store.send(.pulledToRefresh) { $0.isRefreshing = true }
    #expect(!store.state.showsEmptyView)
    await store.receive(\.stationsResponse.success) {
      $0.isRefreshing = false
      $0.$stations.withLock { $0 = [saved, other] }
    }
    expectNoDifference(store.state.favoriteStations, [saved])
    #expect(!store.state.showsEmptyView)
  }

  @Test
  func failedRefreshKeepsCachedFavoritesAndDismissesError() async {
    let saved = makeStation("1001")
    let clock = TestClock()
    let store = TestStore(initialState: favoriteState(codes: [saved.code], stations: [saved])) {
      FavoriteFeature()
    } withDependencies: {
      $0.apiClient = StubAPI { throw FetchError.offline }
      $0.continuousClock = clock
    }

    await store.send(.pulledToRefresh) { $0.isRefreshing = true }
    await store.receive(\.stationsResponse.failure) {
      $0.isRefreshing = false
      $0.showsError = true
    }
    expectNoDifference(store.state.favoriteStations, [saved])
    await clock.advance(by: .seconds(2))
    await store.receive(\.errorDisplayElapsed) { $0.showsError = false }
  }

  @Test
  func leavingFavoritesCancelsRefreshAndClearsLoading() async {
    let clock = TestClock()
    let store = TestStore(initialState: favoriteState()) {
      FavoriteFeature()
    } withDependencies: {
      $0.apiClient = StubAPI {
        try await clock.sleep(for: .seconds(10))
        return [makeStation("1001")]
      }
    }

    await store.send(.pulledToRefresh) { $0.isRefreshing = true }
    await store.send(.listDisappeared) { $0.isRefreshing = false }
    await clock.advance(by: .seconds(10))
    await store.finish()
    #expect(store.state.showsEmptyView)
  }

  private func favoriteState(codes: [String] = [], stations: [Station] = []) -> FavoriteFeature.State {
    FavoriteFeature.State(favoriteCodes: Shared(value: codes), stations: Shared(value: stations))
  }
}
