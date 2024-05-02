//
//  DetailsReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ComposableArchitecture
import MapKit
import Models
import UserDefaultsClient

@Reducer
public struct DetailsReducer {
  @ObservableState
  public struct State: Equatable {
    public var station: StationMarker
    public var title: String
    public var isFavoriteStation: Bool
    
    public var stationLocation: MKCoordinateRegion
    
    public init(
      station: StationMarker = StationMarker(
        freeDocks: 1,
        code: "123",
        name: "Test name",
        totalDocks: 4,
        freeBikes: 5,
        freeMechanicalBikes: 6,
        freeElectricBikes: 7,
        geolocation: [20, 30]
      ),
      title: String = "",
      isFavoriteStation: Bool = false,
      stationLocation: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
          latitude: 48.866667,
          longitude: 2.333333),
        latitudinalMeters: 2000,
        longitudinalMeters: 2000
      )
    ) {
      self.station = station
      self.title = title
      self.isFavoriteStation = isFavoriteStation
      self.stationLocation = stationLocation
    }
  }
  
  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
    case favoriteButtonTapped
  }
  
  @Dependency(\.userDefaultsClient) public var userDefaultsClient: UserDefaultsClient
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.title = state.station.name
        state.stationLocation = MKCoordinateRegion(
          center: state.station.coordinate,
          latitudinalMeters: 200,
          longitudinalMeters: 200
        )
        
        state.isFavoriteStation = self.userDefaultsClient.isFavoriteStation(code: state.station.code)
        
        return .none
        
      case .favoriteButtonTapped:
        if state.isFavoriteStation {
          state.isFavoriteStation = false
          self.userDefaultsClient.removeFavoriteStations(for: state.station.code)
          
          return .none
          
        } else {
          state.isFavoriteStation = true
          self.userDefaultsClient.addFavoriteStation(for: state.station.code)
          
          return .none
        }
        
      case .binding:
        return .none
      }
    }
    ._printChanges()
  }
}
