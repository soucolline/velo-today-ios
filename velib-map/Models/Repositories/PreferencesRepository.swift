//
//  PreferencesRepository.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

class PreferencesRepository {
  
  private let defaults: UserDefaults
  
  init(with defaults: UserDefaults) {
    self.defaults = defaults
  }
  
  func getMapStyle() -> MapStyle {
    if let identifier = self.defaults.string(forKey: Const.mapStyle),
       let mapStyle = MapStyle(rawValue: identifier) {
      return mapStyle
    } else {
      return MapStyle.normal
    }
  }
  
  func setMapStyle(identifier: String) {
    self.defaults.set(identifier, forKey: Const.mapStyle)
  }

  private struct Const {
    static let mapStyle = "mapStyle"
  }
}
