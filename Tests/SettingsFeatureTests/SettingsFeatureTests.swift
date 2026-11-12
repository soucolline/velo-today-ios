import ComposableArchitecture
@testable import SettingsFeature
import Testing
import UserDefaultsClient

@MainActor
struct SettingsFeatureTests {
  @Test
  func readsVersionAndSavedStyle() async {
    let store = TestStore(initialState: SettingsFeature.State(mapStyle: Shared(value: "hybridStyle"))) {
      SettingsFeature()
    } withDependencies: {
      $0.appVersion = { "2.3.4" }
    }

    expectNoDifference(store.state.selectedPickerIndex, 1)
    await store.send(.onAppear) { $0.appVersion = "2.3.4" }
    await store.send(.pickerSelectionChanged(2)) { $0.$mapStyle.withLock { $0 = "satelliteStyle" } }
    expectNoDifference(store.state.selectedPickerIndex, 2)
  }

  @Test
  func unknownPersistedStyleFallsBackToNormal() {
    let store = TestStore(initialState: SettingsFeature.State(mapStyle: Shared(value: "obsoleteStyle"))) {
      SettingsFeature()
    }

    expectNoDifference(store.state.selectedPickerIndex, 0)
  }
}
