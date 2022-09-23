//
//  TabBarView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 17/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var mapState: MapState = .init()
  var detailsState: DetailsState = .init()
  var settingsState: SettingsState = .init()
  var favoriteState: FavoriteState = .init()
}

enum AppAction: Equatable {
  case map(MapAction)
  case details(DetailsAction)
  case settings(SettingsAction)
  case favorite(FavoriteAction)
}

struct AppEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
  var apiClient: ApiClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  mapReducer.pullback(
    state: \.mapState,
    action: /AppAction.map,
    environment: {
      MapEnvironment(
        apiClient: $0.apiClient,
        userDefaultsClient: $0.userDefaultsClient
      )
    }
  ),
  
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
        apiClient: $0.apiClient,
        mainQueue: $0.mainQueue
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

struct TabBarView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      TabView {
        MapUIKit(
          store: self.store.scope(
            state: \.mapState,
            action: AppAction.map
          )
        )
        .tabItem {
          Label("Stations", systemImage: "bicycle.circle.fill")
        }
        
        FavoriteListView(
          store: self.store.scope(
            state: \.favoriteState,
            action: AppAction.favorite
          )
        )
        .tabItem {
          Label("Favoris", systemImage: "star.circle.fill")
        }
        
        SettingsView(
          store: self.store.scope(
            state: \.settingsState,
            action: AppAction.settings
          )
        )
        .tabItem {
          Label("Réglages", systemImage: "gear.circle.fill")
        }
      }
    }
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(
      store: Store(
        initialState: .init(),
        reducer: appReducer,
        environment: .init(
          userDefaultsClient: .noop,
          getAppVersion: { "123" },
          apiClient: .unimplemented,
          mainQueue: .unimplemented
        )
      )
    )
  }
}
