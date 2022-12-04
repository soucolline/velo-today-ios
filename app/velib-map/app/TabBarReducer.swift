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
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.mapState, action: /Action.map) {
      MapReducer()
    }
    
    Scope(state: \.detailsState, action: /Action.details) {
      DetailsReducer()
    }
    
    Scope(state: \.favoriteState, action: /Action.favorite) {
      FavoriteReducer()
    }
    
    Scope(state: \.settingsState, action: /Action.settings) {
      SettingsReducer()
    }
  }
}
