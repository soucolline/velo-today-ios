import ApiClient
import ComposableArchitecture
import DetailsFeature
import Models

@Reducer
public struct MapFeature {
  @ObservableState
  public struct State: Equatable {
    @Presents var alert: AlertState<Never>?
    var center = MapLocation.paris
    @Presents var details: DetailsFeature.State?
    @Shared var favoriteCodes: [String]
    var hasStarted = false
    var isLoading = false
    @SharedReader var mapStyle: String
    @Shared var stations: [Station]

    var style: MapStyle { MapStyle(rawValue: mapStyle) ?? .normal }

    public init(favoriteCodes: Shared<[String]>, mapStyle: SharedReader<String>, stations: Shared<[Station]>) {
      self._favoriteCodes = favoriteCodes
      self._mapStyle = mapStyle
      self._stations = stations
    }
  }

  public enum Action {
    case alert(PresentationAction<Never>)
    case details(PresentationAction<DetailsFeature.Action>)
    case locationResponse(MapLocation?)
    case onAppear
    case reloadButtonTapped
    case stationPinTapped(Station)
    case stationsResponse(Result<[Station], any Error>)
  }

  private enum CancelID { case stations }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.mapLocation) var mapLocation

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert, .details:
        return .none
      case let .locationResponse(location):
        if let location { state.center = location }
        return .none
      case .onAppear:
        guard !state.hasStarted else { return .none }
        state.hasStarted = true
        state.isLoading = true
        return .merge(
          fetchStations(),
          .run { [mapLocation] send in await send(.locationResponse(mapLocation())) }
        )
      case .reloadButtonTapped:
        state.isLoading = true
        return fetchStations()
      case let .stationPinTapped(station):
        state.details = DetailsFeature.State(station: station, favoriteCodes: state.$favoriteCodes)
        return .none
      case let .stationsResponse(.success(stations)):
        state.isLoading = false
        state.$stations.withLock { $0 = stations }
        return .none
      case .stationsResponse(.failure):
        state.isLoading = false
        state.alert = AlertState {
          TextState("Erreur")
        } actions: {
          ButtonState { TextState("OK") }
        } message: {
          TextState("Impossible de charger les données de certaines stations")
        }
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.$details, action: \.details) { DetailsFeature() }
  }

  private func fetchStations() -> EffectOf<Self> {
    .run { [apiClient] send in
      await send(.stationsResponse(Result { try await apiClient.fetchAllStations() }))
    }
    .cancellable(id: CancelID.stations, cancelInFlight: true)
  }
}
