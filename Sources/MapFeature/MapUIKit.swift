//
//  MapUIKit.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 22/09/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import UserDefaultsClient
import Models
import ApiClient

public struct MapUIKit: UIViewControllerRepresentable {
  let viewModel: MapScreenViewModel
  
  public init(viewModel: MapScreenViewModel) {
    self.viewModel = viewModel
  }
  
  public func makeUIViewController(context: Context) -> some UIViewController {
    UINavigationController(rootViewController: MapViewController(viewModel: viewModel))
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
