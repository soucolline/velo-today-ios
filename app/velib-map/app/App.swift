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
import UserDefaultsClient
import ApiClient
import SettingsFeature
import Firebase

@main
struct Application: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        EmptyView()
      } else {
        TabBarView(
          store: Store(
            initialState: .init(),
            reducer: { TabBarReducer() }
          )
        )
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
