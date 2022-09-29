//
//  MapStyle.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

public enum MapStyle: String, CaseIterable {
  
  case normal = "normalStyle"
  case hybrid = "hybridStyle"
  case satellite = "satelliteStyle"
  
  public var pickerValue: Int {
    switch self {
    case .normal: return 0
    case .hybrid: return 1
    case .satellite: return 2
    }
  }
  
  public static func initFromInt(value: Int) -> MapStyle {
    switch value {
    case 0: return .normal
    case 1: return .hybrid
    case 2: return .satellite
    default: return .normal
    }
  }
  
}
