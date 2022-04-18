//
//  MapRepository.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol MapRepository {
  func getMapStyle() -> MapStyle
  func setMapStyle(identifier: String)
}

class MapRepositoryImpl: MapRepository {
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  func getMapStyle() -> MapStyle {
    if let identifier = self.userDefaults.string(forKey: Const.mapStyle),
       let mapStyle = MapStyle(rawValue: identifier) {
      return mapStyle
    } else {
      return MapStyle.normal
    }
  }

  func setMapStyle(identifier: String) {
    self.userDefaults.set(identifier, forKey: Const.mapStyle)
  }

  private struct Const {
    static let mapStyle = "mapStyle"
  }
}
