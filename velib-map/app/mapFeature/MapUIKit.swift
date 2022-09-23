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

struct MapState: Equatable {
  var stations: [Station] = []
  var hasAlreadyLoadedStations = false
  var errorText = "Impossible de charger les données de certaines stations"
  var mapStyle: MapStyle = .normal
  var shouldShowError = false
  
  var coordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
    latitudinalMeters: 1000 * 2.0,
    longitudinalMeters: 1000 * 2.0
  )
}

enum MapAction: Equatable, BindableAction {
  case fetchAllStations
  case fetchAllStationsResponse(TaskResult<[Station]>)
  case getMapStyle
  case hideError
  case binding(BindingAction<MapState>)
}

struct MapEnvironment {
  var apiClient: ApiClient
  var userDefaultsClient: UserDefaultsClient
}

let mapReducer = Reducer<MapState, MapAction, MapEnvironment> { state, action, environment in
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

struct MapUIKit: UIViewControllerRepresentable {
  let store: Store<MapState, MapAction>
  
  init(store: Store<MapState, MapAction>) {
    self.store = store
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    MapViewController(store: self.store)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
