//
//  MapReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ComposableArchitecture
import MapKit
import Models
import ApiClient

@Reducer
public struct MapReducer {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage("mapStyle")) var mapStyleUserDefaults: String = "normal"
    @Shared(.inMemory("stations")) public var stations: [Station] = []

    public var hasAlreadyLoadedStations: Bool
    public var errorText: String
    public var mapStyle: MapStyle
    public var shouldShowLoader: Bool
    public var shouldShowError: Bool
    public var coordinateRegion: MKCoordinateRegion
    
    public init(
      stations: [Station] = [],
      hasAlreadyLoadedStations: Bool = false,
      errorText: String = "Impossible de charger les données de certaines stations",
      mapStyle: MapStyle = .normal,
      shouldShowLoader: Bool = false,
      shouldShowError: Bool = false,
      coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
        latitudinalMeters: 1000 * 2.0,
        longitudinalMeters: 1000 * 2.0)
    ) {
      self.stations = stations
      self.hasAlreadyLoadedStations = hasAlreadyLoadedStations
      self.errorText = errorText
      self.mapStyle = mapStyle
      self.shouldShowLoader = shouldShowLoader
      self.shouldShowError = shouldShowError
      self.coordinateRegion = coordinateRegion
    }
  }

  public enum Action {
    case fetchAllStations
    case fetchAllStationsResponse(Result<[Station], Error>)
    case getMapStyle
    case hideError
  }

  @Dependency(\.apiClient) public var apiClient
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchAllStations:
        state.shouldShowLoader = true
        return .run(priority: .background) { send in
          await send(.fetchAllStationsResponse(Result { try await self.apiClient.fetchAllStations() }))
        }
        
      case .fetchAllStationsResponse(.success(let stations)):
        state.stations = stations
        state.hasAlreadyLoadedStations = true
        state.shouldShowLoader = false
        return .none
        
      case .fetchAllStationsResponse(.failure):
        state.hasAlreadyLoadedStations = true
        state.shouldShowError = true
        state.shouldShowLoader = false
        return .none
        
      case .getMapStyle:
        let mapStyle = MapStyle(rawValue: state.mapStyleUserDefaults) ?? .normal
        
        state.mapStyle = mapStyle
        return .none
        
      case .hideError:
        state.shouldShowError = false
        return .none
      }
    }
  }
}
