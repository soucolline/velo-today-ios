//
//  MapUIKit.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 22/09/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import MapKit
import UserDefaultsClient
import Models
import ApiClient

public struct MapState: Equatable {
  public var stations: [Station]
  public var hasAlreadyLoadedStations: Bool
  public var errorText: String
  public var mapStyle: MapStyle
  public var shouldShowError: Bool
  public var coordinateRegion: MKCoordinateRegion
  
  public init(
    stations: [Station] = [],
    hasAlreadyLoadedStations: Bool = false,
    errorText: String = "Impossible de charger les données de certaines stations",
    mapStyle: MapStyle = .normal,
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
    self.shouldShowError = shouldShowError
    self.coordinateRegion = coordinateRegion
  }
}

public enum MapAction: Equatable, BindableAction {
  case fetchAllStations
  case fetchAllStationsResponse(TaskResult<[Station]>)
  case getMapStyle
  case hideError
  case binding(BindingAction<MapState>)
}

public struct MapEnvironment {
  public var apiClient: ApiClient
  public var userDefaultsClient: UserDefaultsClient
  
  public init(apiClient: ApiClient, userDefaultsClient: UserDefaultsClient) {
    self.apiClient = apiClient
    self.userDefaultsClient = userDefaultsClient
  }
}

public let mapReducer = Reducer<MapState, MapAction, MapEnvironment> { state, action, environment in
  switch action {
  case .fetchAllStations:
    return .task(priority: .background) {
      await .fetchAllStationsResponse(TaskResult { try await environment.apiClient.fetchAllStations() })
    }
    
  case .fetchAllStationsResponse(.success(let stations)):
    state.stations = stations
    state.hasAlreadyLoadedStations = true
    return .none
    
  case .fetchAllStationsResponse(.failure(let error)):
    state.hasAlreadyLoadedStations = true
    state.shouldShowError = true
    return .none
    
  case .getMapStyle:
    let mapStyleUserDefaults = environment.userDefaultsClient.stringForKey("mapStyle") ?? "normal"
    let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
    
    state.mapStyle = mapStyle
    return .none
    
  case .hideError:
    state.shouldShowError = false
    return .none
    
  case .binding:
    return .none
  }
}
.debug()

public struct MapUIKit: UIViewControllerRepresentable {
  let store: Store<MapState, MapAction>
  
  public init(store: Store<MapState, MapAction>) {
    self.store = store
  }
  
  public func makeUIViewController(context: Context) -> some UIViewController {
    MapViewController(store: self.store)
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
