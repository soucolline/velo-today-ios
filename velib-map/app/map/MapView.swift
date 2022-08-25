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
  var stations: [Station] = []
  var hasAlreadyLoadedStations = false
  
  var coordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
    latitudinalMeters: 1000 * 2.0,
    longitudinalMeters: 1000 * 2.0
  )
}

enum MapAction: Equatable {
  case fetchAllStations
  case fetchAllStationsResponse(TaskResult<[Station]>)
}

struct MapEnvironment {
  var apiClient: ApiClient
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
    return .none
  }
}
.debug()

struct MapView: View {
  let store: Store<MapState, MapAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        VStack {
          Map(coordinateRegion: .constant(viewStore.coordinateRegion), interactionModes: [.all], annotationItems: viewStore.stations.map { $0.toStationPin() }) { item in
            MapAnnotation(coordinate: item.coordinate) {
              NavigationLink(
                destination: DetailsView(
                  store: Store(
                    initialState: .init(station: item),
                    reducer: detailsReducer,
                    environment: .init(userDefaultsClient: .live())
                  )
                )
              ) {
                ZStack {
                  Circle()
                    .fill(getPinColor(item: item))
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
      .navigationViewStyle(.stack)
      .task {
        if viewStore.hasAlreadyLoadedStations == false {
          viewStore.send(.fetchAllStations)
        }
      }
    }
  }
  
  private func getPinColor(item: StationMarker) -> Color {
    if item.freeBikes == 0 {
      return .red
    } else if (item.freeBikes / item.totalDocks) * 100 <= 30 {
      return .orange
    } else {
      return .green
    }
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(
      store: Store(
        initialState: MapState(),
        reducer: mapReducer,
        environment: MapEnvironment(apiClient: .live)
      )
    )
  }
}
