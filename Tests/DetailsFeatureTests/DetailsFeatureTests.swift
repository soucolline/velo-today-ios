import ComposableArchitecture
@testable import DetailsFeature
import Testing
import TestSupport

@MainActor
struct DetailsFeatureTests {
  @Test
  func togglingFavoritePreservesOtherFavorites() async {
    let station = makeStation("1001")
    let store = TestStore(initialState: DetailsFeature.State(station: station, favoriteCodes: Shared(value: ["1002"]))) {
      DetailsFeature()
    }

    #expect(!store.state.isFavoriteStation)
    await store.send(.favoriteButtonTapped) { $0.$favoriteCodes.withLock { $0.append("1001") } }
    #expect(store.state.isFavoriteStation)
    await store.send(.favoriteButtonTapped) { $0.$favoriteCodes.withLock { $0 = ["1002"] } }
    #expect(!store.state.isFavoriteStation)
  }
}
