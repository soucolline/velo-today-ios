import ComposableArchitecture
import Models

@Reducer
public struct DetailsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared var favoriteCodes: [String]
    public let station: Station

    public var isFavoriteStation: Bool { favoriteCodes.contains(station.code) }

    public init(station: Station, favoriteCodes: Shared<[String]>) {
      self.station = station
      self._favoriteCodes = favoriteCodes
    }
  }

  public enum Action {
    case favoriteButtonTapped
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .favoriteButtonTapped:
        let code = state.station.code
        state.$favoriteCodes.withLock { codes in
          if codes.contains(code) {
            codes.removeAll { $0 == code }
          } else {
            codes.append(code)
          }
        }
        return .none
      }
    }
  }
}
