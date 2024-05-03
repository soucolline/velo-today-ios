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
  @Perception.Bindable var store: StoreOf<SettingsReducer>
  
  public init(store: StoreOf<SettingsReducer>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      NavigationView {
        List {
          Section(header: Text("Type de carte ")) {
            Picker("toto", selection: $store.selectedPickerIndex) {
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
              Text(store.appVersion)
                .opacity(0.8)
                .foregroundColor(.gray)
            }
            
          }
        }
        .navigationTitle("Réglages")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
          store.send(.onAppear)
        }
      }
    }
  }
}

#Preview {
  SettingsView(
    store: Store(
      initialState: .init(),
      reducer: { SettingsReducer() }
    )
  )
}
