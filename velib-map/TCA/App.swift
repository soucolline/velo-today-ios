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
}

enum AppAction: Equatable {
  case details(DetailsAction)
  case settings(SettingsAction)
}

struct AppEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
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
