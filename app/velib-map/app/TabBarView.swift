//
//  TabBarView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 17/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UserDefaultsClient
import ApiClient
import SettingsFeature
import DetailsFeature
import FavoriteFeature
import MapFeature

struct TabBarView: View {
  let store: StoreOf<TabBarReducer>
  
  var body: some View {
    WithPerceptionTracking {
      NavigationView {
        TabView {
          MapUIKit(
            store: self.store.scope(
              state: \.mapState,
              action: \.map
            )
          )
          .tabItem {
            Label("Stations", systemImage: "bicycle.circle.fill")
          }
          
          FavoriteListView(
            store: self.store.scope(
              state: \.favoriteState,
              action: \.favorite
            )
          )
          .tabItem {
            Label("Favoris", systemImage: "star.circle.fill")
          }
          
          SettingsView(
            store: self.store.scope(
              state: \.settingsState,
              action: \.settings
            )
          )
          .tabItem {
            Label("Réglages", systemImage: "gear.circle.fill")
          }
        }
      }
    }
  }
}

#if DEBUG
struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(
      store: Store(
        initialState: .init(),
        reducer: { TabBarReducer() }
      )
    )
  }
}
#endif
