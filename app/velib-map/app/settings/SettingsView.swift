//
//  SettingsView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 06/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

struct SettingsState: Equatable {
  var mapStyle = MapStyle.normal
  var appVersion = "1.0.0"
  @BindableState var selectedPickerIndex = 0
}

enum SettingsAction: Equatable, BindableAction {
  case onAppear
  case binding(BindingAction<SettingsState>)
}

struct SettingsEnvironment {
  var userDefaultsClient: UserDefaultsClient
  var getAppVersion: () -> String
}

let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    let mapStyleUserDefaults = environment.userDefaultsClient.stringForKey("mapStyle") ?? "normal"
    
    let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
    
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

struct SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  
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
    SettingsView(
      store: Store(
        initialState: SettingsState(),
        reducer: settingsReducer,
        environment: SettingsEnvironment(
          userDefaultsClient: .noop,
          getAppVersion: { "1.234.567" }
        )
      )
    )
  }
}
