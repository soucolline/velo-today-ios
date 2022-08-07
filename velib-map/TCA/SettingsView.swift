//
//  SettingsView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 06/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var mapStyle = MapStyle.normal
  var appVersion = "1.0.0"
  @BindableState var selectedPickerIndex = 0
}

enum AppAction: Equatable, BindableAction {
  case onAppear
  case binding(BindingAction<AppState>)
}

struct AppEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    guard let mapStyleUserDefaults = environment.userDefaultsClient.stringForKey("mapStyle") else {
      return .none
    }
    
    guard let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) else {
      return .none
    }
    
    state.mapStyle = mapStyle
    state.selectedPickerIndex = mapStyle.pickerValue
    state.appVersion = environment.getAppVersion()
    
    return .none
  
  case .binding(\.$selectedPickerIndex):
    state.mapStyle = MapStyle.initFromInt(value: state.selectedPickerIndex)
    
    return environment.userDefaultsClient
      .setString(state.mapStyle.rawValue, "mapStyle")
      .fireAndForget()
    
  case .binding:
    return .none
  }
}
.binding()
.debug()

struct SettingsViewTCA: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          Section(header: Text("Type de carte ")) {
            Picker("toto", selection: viewStore.binding(\.$selectedPickerIndex)) {
              Text("Normal").tag(0)
              Text("Hybrid").tag(1)
              Text("Sattelite").tag(2)
            }
            .pickerStyle(.segmented)
          }
          
          Section(header: Text("App information")) {
            HStack {
              Text("Version number")
              Spacer()
              Text(viewStore.state.appVersion)
                .opacity(0.8)
                .foregroundColor(.gray)
            }
            
          }
        }
        .navigationTitle("Réglages")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
          viewStore.send(.onAppear)
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsViewTCA(
      store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
          userDefaultsClient: .noop,
          getAppVersion: { "1.234.567" }
        )
      )
    )
  }
}
