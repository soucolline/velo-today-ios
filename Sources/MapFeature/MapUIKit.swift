//
//  MapUIKit.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 22/09/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import MapKit
import UserDefaultsClient
import Models
import ApiClient

public struct MapUIKit: UIViewControllerRepresentable {
  let store: StoreOf<MapReducer>
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public func makeUIViewController(context: Context) -> some UIViewController {
    UINavigationController(rootViewController: MapViewController(store: self.store))
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
