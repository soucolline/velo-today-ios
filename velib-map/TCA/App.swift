//
//  App.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 07/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct AppState: Equatable {
  var detailsState: DetailsState = .init()
  var settingsState: SettingsState = .init()
  var favoriteState: FavoriteState = .init()
}

enum AppAction: Equatable {
  case details(DetailsAction)
  case settings(SettingsAction)
  case favorite(FavoriteAction)
}

struct AppEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
  var apiClient: ApiClient
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  detailsReducer.pullback(
    state: \.detailsState,
    action: /AppAction.details,
    environment: {
      DetailsEnvironment(
        userDefaultsClient: $0.userDefaultsClient
      )
    }
  ),
  
  favoriteReducer.pullback(
    state: \.favoriteState,
    action: /AppAction.favorite,
    environment: {
      FavoriteEnvironment(
        userDefaultsClient: $0.userDefaultsClient,
        apiClient: $0.apiClient
      )
    }
  ),
  
  settingsReducer.pullback(
    state: \.settingsState,
    action: /AppAction.settings,
    environment: {
      SettingsEnvironment(
        userDefaultsClient: $0.userDefaultsClient,
        getAppVersion: $0.getAppVersion
      )
    }
  )
)
.debug()
