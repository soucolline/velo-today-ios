//
//  App.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 07/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@main
struct Application: App {
  var body: some Scene {
    WindowGroup {
      TabBarView(
        store: Store(
          initialState: .init(),
          reducer: appReducer,
          environment: .init(
            userDefaultsClient: .live(),
            getAppVersion: { Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String },
            apiClient: .live
          )
        )
      )
    }
  }
}
