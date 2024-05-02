//
//  FavoriteReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ApiClient
import ComposableArchitecture
import DetailsFeature
import Foundation
import UserDefaultsClient
import Models

@Reducer
public struct FavoriteReducer {
  @ObservableState
  public struct State: Equatable {
//    @Shared(.appStorage("favoriteStationsCode")) var favoriteStationsCode: [String] = []
    @Shared(.inMemory("stations")) public var stations: [Station] = []

    public var favoriteStations: [Station] = []
    public var detailState: DetailsReducer.State
    public var isFetchStationRequestInFlight: Bool
    public var errorText: String
    
    public var shouldShowError: Bool
    public var shouldShowEmptyView: Bool
    
    public init(
      detailState: DetailsReducer.State = .init(),
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
  
  public enum Action: BindableAction {
    case onAppear
    case detailsAction(DetailsReducer.Action)
    case fetchFavoriteStations
    case fetchFavoriteStationsResponse(Result<[Station], Error>)
    case hideErrorView
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.userDefaultsClient) public var userDefaultsClient
  @Dependency(\.apiClient) public var apiClient
  @Dependency(\.mainQueue) public var mainQueue
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard let stationsIds = self.userDefaultsClient.arrayForKey("favoriteStationsCode"),
              !stationsIds.isEmpty else {
          return .none
        }
        
        state.favoriteStations = state.stations.filter { stationsIds.contains($0.code) }
        
        return .none
        
      case .fetchFavoriteStations:
        state.favoriteStations = []
        state.isFetchStationRequestInFlight = true
        state.shouldShowEmptyView = false
        
        return .run { send in
          await send(
            .fetchFavoriteStationsResponse(
              Result { try await self.apiClient.fetchAllStations() }
            )
          )
        }
        
      case .hideErrorView:
        state.shouldShowError = false
        return .none
        
      case .fetchFavoriteStationsResponse(.success(let stationResponse)):
        guard let stationsIds = self.userDefaultsClient.arrayForKey("favoriteStationsCode"),
              !stationsIds.isEmpty else {
          return .none
        }
        
        state.stations = stationResponse
        state.favoriteStations = stationResponse.filter { stationsIds.contains($0.code) }
        state.isFetchStationRequestInFlight = false
        
        return .none
        
      case .fetchFavoriteStationsResponse(.failure):
          state.isFetchStationRequestInFlight = false
          state.shouldShowError = true
        return .run { send in
          try await self.mainQueue.sleep(for: 2)
          return await send(.hideErrorView)
        }
        
      case .binding:
        return .none
        
      case .detailsAction:
        return .none
      }
    }
  }
}
