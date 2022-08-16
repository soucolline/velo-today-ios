//
//  MapView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 15/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import MapKit

struct MapState: Equatable {
  var stations: [UIStation] = []
  var hasAlreadyLoadedStations = false
  
  var coordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
    latitudinalMeters: 1000 * 2.0,
    longitudinalMeters: 1000 * 2.0
  )
}

enum MapAction {
  case fetchAllStations
  case fetchAllStationsResponse(TaskResult<[DomainStation]>)
}

struct MapEnvironment {
  var apiClient: ApiClient
}

let mapReducer = Reducer<MapState, MapAction, MapEnvironment> { state, action, environment in
  switch action {
  case .fetchAllStations:
    return .task {
      await .fetchAllStationsResponse(TaskResult { try await environment.apiClient.fetchAllStations() })
    }
    
  case .fetchAllStationsResponse(.success(let stations)):
    state.stations = stations.map { $0.toUIITem() }
    state.hasAlreadyLoadedStations = true
    return .none
    
  case .fetchAllStationsResponse(.failure(let error)):
    print(error)
    state.hasAlreadyLoadedStations = true
    return .none
  }
}
.debug()

struct MapViewTCA: View {
  let store: Store<MapState, MapAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        VStack {
          Map(coordinateRegion: .constant(viewStore.coordinateRegion), interactionModes: [.all], annotationItems: viewStore.stations) { item in
            MapAnnotation(coordinate: item.coordinate) {
              NavigationLink(
                destination: DetailsViewTCA(
                  store: Store(
                    initialState: .init(station: item),
                    reducer: detailsReducer,
                    environment: .init(userDefaultsClient: .live())
                  )
                )
              ) {
                ZStack {
                  Circle()
                    .fill(.orange)
                    .frame(width: 30, height: 30)
                  
                  Text("\(item.freeBikes)")
                    .foregroundColor(.white)
                }
              }
            }
          }
        }
        .navigationTitle("Stations disponibles")
        .toolbar {
          Button { viewStore.send(.fetchAllStations) } label: {  Image(systemName: "gobackward") }
        }
      }
      .task {
        if viewStore.hasAlreadyLoadedStations == false {
          viewStore.send(.fetchAllStations)
        }
      }
    }
  }
}

struct MapViewTCA_Previews: PreviewProvider {
  static var previews: some View {
    MapViewTCA(
      store: Store(
        initialState: MapState(),
        reducer: mapReducer,
        environment: MapEnvironment(apiClient: .live)
      )
    )
  }
}
