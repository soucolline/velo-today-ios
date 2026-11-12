//
//  App.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 07/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import AppFeature
import Firebase
import SwiftUI

@main
struct Application: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  private let screen = AppScreen()

  var body: some Scene {
    WindowGroup {
      screen
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
