//
//  TabBarReducer.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 04/12/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import UserDefaultsClient
import ApiClient
import Foundation
import SettingsFeature
import DetailsFeature
import FavoriteFeature
import MapFeature

struct TabBarReducer: ReducerProtocol {
  struct State: Equatable {
    var mapState: MapReducer.State = .init()
    var detailsState: DetailsReducer.State = .init()
    var settingsState: SettingsReducer.State = .init()
    var favoriteState: FavoriteReducer.State = .init()
  }
  
  enum Action: Equatable {
    case map(MapReducer.Action)
    case details(DetailsReducer.Action)
    case settings(SettingsReducer.Action)
    case favorite(FavoriteReducer.Action)
  }
  
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
  var apiClient: ApiClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
  
  init(
    userDefaultsClient: UserDefaultsClient,
    getAppVersion: @escaping () -> String,
    apiClient: ApiClient,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.userDefaultsClient = userDefaultsClient
    self.getAppVersion = getAppVersion
    self.apiClient = apiClient
    self.mainQueue = mainQueue
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.mapState, action: /Action.map) {
      MapReducer(apiClient: apiClient, userDefaultsClient: userDefaultsClient)
    }
    
    Scope(state: \.detailsState, action: /Action.details) {
      DetailsReducer(userDefaultsClient: userDefaultsClient)
    }
    
    Scope(state: \.favoriteState, action: /Action.favorite) {
      FavoriteReducer(userDefaultsClient: userDefaultsClient, apiClient: apiClient, mainQueue: mainQueue)
    }
    
    Scope(state: \.settingsState, action: /Action.settings) {
      SettingsReducer(userDefaultsClient: userDefaultsClient, getAppVersion: getAppVersion)
    }
  }
}
