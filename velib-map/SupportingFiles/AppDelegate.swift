//
//  AppDelegate.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import CoreStore
import Fabric
import Crashlytics
import ZLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = UIColor.orange
    UIApplication.shared.setStatusBarHidden(false, with: .none)
    
    let dataStack = DataStack(
      xcodeModelName: "velibMap",
      migrationChain: []
    )
    do {
     try dataStack.addStorageAndWait()
    } catch { 
      ZLogger.log(message: "Could not create Database", event: .error)
    }
    
    CoreStore.defaultStack = dataStack
    
    Fabric.with([Crashlytics.self])
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}
