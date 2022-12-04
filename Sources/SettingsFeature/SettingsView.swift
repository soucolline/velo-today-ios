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
import Models

public struct SettingsView: View {
  let store: StoreOf<SettingsReducer>
  
  public init(store: StoreOf<SettingsReducer>) {
    self.store = store
  }
  
  public var body: some View {
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

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(
      store: Store(
        initialState: SettingsReducer.State(),
        reducer: SettingsReducer(userDefaultsClient: .noop, getAppVersion: { "1.234.567" })
      )
    )
  }
}
#endif
