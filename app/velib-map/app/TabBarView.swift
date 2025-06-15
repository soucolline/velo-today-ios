//
//  TabBarView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 17/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI
import UserDefaultsClient
import ApiClient
import SettingsFeature
import DetailsFeature
import FavoriteFeature
import MapFeature
import Perception

struct TabBarView: View {
  var body: some View {
    WithPerceptionTracking {
      NavigationView {
        TabView {
          MapUIKit(
            viewModel: MapScreenViewModel()
          )
          .ignoresSafeAreaForiOS26()
          .tabItem {
            Label("Stations", systemImage: "bicycle.circle.fill")
          }
          
          FavoriteListScreen(
            viewModel: FavoriteScreenViewModel()
          )
          .tabItem {
            Label("Favoris", systemImage: "star.circle.fill")
          }
          
          SettingsScreen(
            viewModel: SettingsScreenViewModel()
          )
          .tabItem {
            Label("Réglages", systemImage: "gear.circle.fill")
          }
        }
      }
    }
  }
}

#Preview {
  TabBarView()
}

private extension View {
  @ViewBuilder
  func ignoresSafeAreaForiOS26() -> some View {
    if #available(iOS 26.0, *) {
      ignoresSafeArea()
    } else {
      self
    }
  }
}
