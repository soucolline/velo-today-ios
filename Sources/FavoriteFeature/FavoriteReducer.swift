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

public struct FavoriteReducer: ReducerProtocol {
  public struct State: Equatable {
    public var detailState: DetailsReducer.State
    public var stations: [Station]
    public var isFetchStationRequestInFlight: Bool
    public var errorText: String
    
    @BindableState public var shouldShowError: Bool
    @BindableState public var shouldShowEmptyView: Bool
    
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
  
  public enum Action: Equatable, BindableAction {
    case detailsAction(DetailsReducer.Action)
    case fetchFavoriteStations
    case fetchFavoriteStationsResponse(TaskResult<[Station]>)
    case hideErrorView
    case binding(BindingAction<State>)
  }
  
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
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchFavoriteStations:
        state.stations = []
        state.isFetchStationRequestInFlight = true
        
        guard let stationsIds = self.userDefaultsClient.arrayForKey("favoriteStationsCode"),
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
              try await self.apiClient.fetchAllStations().filter { station in
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
        
      case .fetchFavoriteStationsResponse(.failure):
          state.isFetchStationRequestInFlight = false
          state.shouldShowError = true
        return .task {
          try await self.mainQueue.sleep(for: 2)
          return .hideErrorView
        }
        
      case .binding:
        return .none
        
      case .detailsAction:
        return .none
      }
    }
  }
}
