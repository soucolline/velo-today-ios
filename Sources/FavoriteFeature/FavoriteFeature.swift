import ApiClient
import ComposableArchitecture
import DetailsFeature
import Models

@Reducer
public struct FavoriteFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared var favoriteCodes: [String]
    var isRefreshing = false
    var path = StackState<DetailsFeature.State>()
    var showsError = false
    @Shared var stations: [Station]

    public var favoriteStations: [Station] {
      let codes = Set(favoriteCodes)
      return stations.filter { codes.contains($0.code) }
    }

    var showsEmptyView: Bool { !isRefreshing && !showsError && favoriteStations.isEmpty }

    public init(favoriteCodes: Shared<[String]>, stations: Shared<[Station]>) {
      self._favoriteCodes = favoriteCodes
      self._stations = stations
    }
  }

  public enum Action {
    case errorDisplayElapsed
    case listDisappeared
    case path(StackActionOf<DetailsFeature>)
    case pulledToRefresh
    case stationTapped(Station)
    case stationsResponse(Result<[Station], any Error>)
  }

  private enum CancelID { case errorDisplay, stations }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.continuousClock) var clock

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .errorDisplayElapsed:
        state.showsError = false
        return .none
      case .listDisappeared:
        state.isRefreshing = false
        state.showsError = false
        return .merge(.cancel(id: CancelID.stations), .cancel(id: CancelID.errorDisplay))
      case .path:
        return .none
      case .pulledToRefresh:
        state.isRefreshing = true
        state.showsError = false
        return .merge(
          .cancel(id: CancelID.errorDisplay),
          .run { [apiClient] send in
            await send(.stationsResponse(Result { try await apiClient.fetchAllStations() }))
          }
          .cancellable(id: CancelID.stations, cancelInFlight: true)
        )
      case let .stationTapped(station):
        state.path.append(DetailsFeature.State(station: station, favoriteCodes: state.$favoriteCodes))
        return .none
      case let .stationsResponse(.success(stations)):
        state.isRefreshing = false
        state.$stations.withLock { $0 = stations }
        return .none
      case .stationsResponse(.failure):
        state.isRefreshing = false
        state.showsError = true
        return .run { [clock] send in
          try await clock.sleep(for: .seconds(2))
          await send(.errorDisplayElapsed)
        }
        .cancellable(id: CancelID.errorDisplay, cancelInFlight: true)
      }
    }
    .forEach(\.path, action: \.path) { DetailsFeature() }
  }
}
