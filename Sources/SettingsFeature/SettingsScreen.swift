//
//  SettingsScreen.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 06/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI
import UserDefaultsClient
import Models

public struct SettingsScreen: View {
  @Bindable var viewModel: SettingsScreenViewModel
  
  public init(viewModel: SettingsScreenViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    NavigationView {
      List {
        Section(header: Text("Type de carte ")) {
          Picker("toto", selection: $viewModel.selectedPickerIndex) {
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
            Text(viewModel.appVersion)
              .opacity(0.8)
              .foregroundColor(.gray)
          }
          
        }
      }
      .navigationTitle("Réglages")
      .navigationBarTitleDisplayMode(.large)
      .onAppear {
        viewModel.onAppear()
      }
    }
  }
}

#Preview {
  SettingsScreen(
    viewModel: SettingsScreenViewModel()
  )
}
