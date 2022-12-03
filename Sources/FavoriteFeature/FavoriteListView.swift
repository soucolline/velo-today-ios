//
//  FavoriteListView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import ApiClient
import UserDefaultsClient
import Models
import DetailsFeature

public struct FavoriteState: Equatable {
  public var detailState: DetailsState
  public var stations: [Station]
  public var isFetchStationRequestInFlight: Bool
  public var errorText: String
  
  @BindableState public var shouldShowError: Bool
  @BindableState public var shouldShowEmptyView: Bool
  
  public init(
    detailState: DetailsState = .init(),
    stations: [Station] = [],
    isFetchStationRequestInFlight: Bool = false,
    errorText: String = "Impossible de charger les données de certaines stations",
    shouldShowError: Bool = false,
    shouldShowEmptyView: Bool = false
  ) {
    self.detailState = detailState
    self.stations = stations
    self.isFetchStationRequestInFlight = isFetchStationRequestInFlight
    self.errorText = errorText
    self.shouldShowError = shouldShowError
    self.shouldShowEmptyView = shouldShowEmptyView
  }
}

public enum FavoriteAction: Equatable, BindableAction {
  case detailsAction(DetailsAction)
  case fetchFavoriteStations
  case fetchFavoriteStationsResponse(TaskResult<[Station]>)
  case hideErrorView
  case binding(BindingAction<FavoriteState>)
}

public struct FavoriteEnvironment {
  public var userDefaultsClient: UserDefaultsClient
  public var apiClient: ApiClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    userDefaultsClient: UserDefaultsClient = .live(),
    apiClient: ApiClient = .live,
    mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
  ) {
    self.userDefaultsClient = userDefaultsClient
    self.apiClient = apiClient
    self.mainQueue = mainQueue
  }
}

public let favoriteReducer = Reducer<FavoriteState, FavoriteAction, FavoriteEnvironment> { state, action, environment in
  switch action {
  case .fetchFavoriteStations:
    state.stations = []
    state.isFetchStationRequestInFlight = true
    
    guard let stationsIds = environment.userDefaultsClient.arrayForKey("favoriteStationsCode"),
          !stationsIds.isEmpty
    else {
      state.isFetchStationRequestInFlight = false
      state.shouldShowEmptyView = true
      return .none
    }
    
    state.shouldShowEmptyView = false
    
    return .task {
      await .fetchFavoriteStationsResponse(
        TaskResult {
          try await environment.apiClient.fetchAllStations().filter { station in
            return stationsIds.first(where: { id in id == station.code }) != nil
          }
        }
      )
    }
    
  case .hideErrorView:
    state.shouldShowError = false
    return .none
    
  case .fetchFavoriteStationsResponse(.success(let stationResponse)):
    state.isFetchStationRequestInFlight = false
    state.stations = stationResponse
    return .none
    
  case .fetchFavoriteStationsResponse(.failure(let error)):
      state.isFetchStationRequestInFlight = false
      state.shouldShowError = true
    return .task {
      try await environment.mainQueue.sleep(for: 2)
      return .hideErrorView
    }
    
  case .binding:
    return .none
    
  case .detailsAction:
    return .none
  }
}
.binding()

public struct FavoriteListView: View {
  let store: Store<FavoriteState, FavoriteAction>
  
  public init(store: Store<FavoriteState, FavoriteAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        ZStack {
          List {
            if viewStore.isFetchStationRequestInFlight {
              ForEach(0..<3) { _ in
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
          
          if viewStore.shouldShowEmptyView {
            FavoriteEmptyView()
          }
          
          ErrorView(
            errorText: .constant(viewStore.errorText),
            isVisible: viewStore.binding(\.$shouldShowError)
          )
        }
      }
      .navigationViewStyle(.stack)
      .refreshable {
        viewStore.send(.fetchFavoriteStations)
      }
      .task {
        viewStore.send(.fetchFavoriteStations)
      }
    }
  }
}

#if DEBUG
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
            ),
            Station(
              freeDocks: 1,
              code: "Code",
              name: "Name of the station but super long",
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
          apiClient: .unimplemented,
          mainQueue: .main
        )
      )
    )
  }
}
#endif
