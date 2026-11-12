import ComposableArchitecture
import Models
import UserDefaultsClient

@Reducer
public struct SettingsFeature {
  @ObservableState
  public struct State: Equatable {
    var appVersion = "—"
    @Shared var mapStyle: String

    var selectedPickerIndex: Int { (MapStyle(rawValue: mapStyle) ?? .normal).pickerValue }

    public init(mapStyle: Shared<String>) {
      self._mapStyle = mapStyle
    }
  }

  public enum Action {
    case onAppear
    case pickerSelectionChanged(Int)
  }

  @Dependency(\.appVersion) var appVersion

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.appVersion = appVersion()
        return .none
      case let .pickerSelectionChanged(index):
        state.$mapStyle.withLock { $0 = MapStyle.initFromInt(value: index).rawValue }
        return .none
      }
    }
  }
}
