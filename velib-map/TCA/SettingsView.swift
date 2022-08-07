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
  
}

enum AppAction: Equatable {
  case onAppear
}

struct AppEnvironment: Equatable {
  
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  }
}

struct SettingsViewTCA: View {
  @State private var selectedPicker = 0
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Type de carte ")) {
          Picker("toto", selection: $selectedPicker) {
            Text("Value 1").tag(0)
            Text("Value 2").tag(1)
            Text("Value 3").tag(2)
          }
          .pickerStyle(.segmented)
        }
      }
      .navigationTitle("Réglages")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SettingsViewTCA()
    }
  }
}
