//
//  FavoriteListView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct FavoriteState: Equatable {
  var detailState: DetailsState = .init()
  var stations: [Station] = []
  var isFetchStationRequestInFlight = false
  
  @BindableState var shouldShowError = false
}

enum FavoriteAction: Equatable, BindableAction {
  case detailsAction(DetailsAction)
  case fetchFavoriteStations
  case fetchFavoriteStationsResponse(TaskResult<[Station]>)
  case binding(BindingAction<FavoriteState>)
}

struct FavoriteEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var apiClient: ApiClient
}

let favoriteReducer = Reducer<FavoriteState, FavoriteAction, FavoriteEnvironment> { state, action, environment in
  switch action {
  case .fetchFavoriteStations:
    state.stations = []
    state.isFetchStationRequestInFlight = true
    
    guard let stationsIds = environment.userDefaultsClient.arrayForKey("favoriteStationsCode") else {
      state.isFetchStationRequestInFlight = false
      return .none
    }
    
    return .task {
      var stations: [Station] = []
      
      for id in stationsIds {
        do {
          let stationId = try await environment.apiClient.fetchStation(id)
          stations.append(stationId)
        } catch let error {
          return .fetchFavoriteStationsResponse(TaskResult.failure(error))
        }
      }
      
      return await .fetchFavoriteStationsResponse(TaskResult { [stations] in stations })
    }
    
  case .fetchFavoriteStationsResponse(.success(let stationResponse)):
    state.isFetchStationRequestInFlight = false
    state.stations = stationResponse
    return .none
    
  case .fetchFavoriteStationsResponse(.failure(let error)):
      state.isFetchStationRequestInFlight = false
      state.shouldShowError = true
    return .none
    
  case .binding:
    return .none
    
  case .detailsAction:
    return .none
  }
}
.binding()

struct FavoriteListView: View {
  let store: Store<FavoriteState, FavoriteAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        List {
          if viewStore.isFetchStationRequestInFlight {
            ForEach(0..<10) { _ in
              FavoriteEmptyCell()
            }
          } else {
            ForEach(viewStore.stations) { station in
              NavigationLink(
                destination: DetailsView(
                  store: Store(
                    initialState: DetailsState(
                      station: station.toStationPin(),
                      title: station.name,
                      isFavoriteStation: true),
                    reducer: detailsReducer,
                    environment: DetailsEnvironment(userDefaultsClient: .live())
                  )
                )
              ) {
                FavoriteCell(name: station.name, freeBikes: station.freeBikes, freeDocks: station.freeDocks)
              }
            }
          }
        }
        .navigationTitle("Favoris")
        .task {
          viewStore.send(.fetchFavoriteStations)
        }
      }
      .navigationViewStyle(.stack)
      .refreshable {
        viewStore.send(.fetchFavoriteStations)
      }
      .alert(isPresented: viewStore.binding(\.$shouldShowError)) {
        Alert(title: Text("Erreur"), message: Text("Impossible de charger les données de certaines stations"))
      }
    }
  }
}

struct FavoriteListView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteListView(
      store: Store(
        initialState: FavoriteState(
          stations: [
            Station(
              freeDocks: 12,
              code: "Code",
              name: "Name of the station",
              totalDocks: 12,
              freeBikes: 10,
              freeMechanicalBikes: 14,
              freeElectricBikes: 15,
              geolocation: [12, 13]
            )
          ],
          isFetchStationRequestInFlight: false
        ),
        reducer: favoriteReducer,
        environment: .init(
          userDefaultsClient: .noop,
          apiClient: .unimplemented
        )
      )
    )
  }
}
