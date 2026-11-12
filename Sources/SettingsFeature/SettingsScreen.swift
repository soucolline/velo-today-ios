//
//  SettingsScreen.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 06/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Models

public struct SettingsScreen: View {
  @Bindable var store: StoreOf<SettingsFeature>
  
  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Type de carte ")) {
          Picker("Type de carte", selection: $store.selectedPickerIndex.sending(\.pickerSelectionChanged)) {
            Text("Normal").tag(0)
            Text("Hybrid").tag(1)
            Text("Satellite").tag(2)
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
