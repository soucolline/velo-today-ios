//
//  MapReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ComposableArchitecture
import MapKit
import UserDefaultsClient
import Models
import ApiClient

public struct MapReducer: ReducerProtocol {
  public struct State: Equatable {
    public var stations: [Station]
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

  public enum Action: Equatable {
    case fetchAllStations
    case fetchAllStationsResponse(TaskResult<[Station]>)
    case getMapStyle
    case hideError
  }

  public var apiClient: ApiClient
  public var userDefaultsClient: UserDefaultsClient
  
  public init(apiClient: ApiClient, userDefaultsClient: UserDefaultsClient) {
    self.apiClient = apiClient
    self.userDefaultsClient = userDefaultsClient
  }
  
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .fetchAllStations:
      state.shouldShowLoader = true
      return .task(priority: .background) {
        await .fetchAllStationsResponse(TaskResult { try await self.apiClient.fetchAllStations() })
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
      let mapStyleUserDefaults = self.userDefaultsClient.stringForKey("mapStyle") ?? "normal"
      let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
      
      state.mapStyle = mapStyle
      return .none
      
    case .hideError:
      state.shouldShowError = false
      return .none
    }
  }
}
