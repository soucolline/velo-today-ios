//
//  FavoriteLocalDataSource.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol FavoriteLocalDataSource {
  func getFavoriteStationsIds() -> [String]
  func addFavoriteStation(for code: String)
  func removeFavoriteStations(for code: String)
  func isFavoriteStation(from code: String) -> Bool
  func getNumberOfFavoriteStations() -> Int
}

class FavoriteLocalDataSourceImpl: FavoriteLocalDataSource {
  private let defaults: UserDefaults

  init(with defaults: UserDefaults) {
    self.defaults = defaults
  }

  func getFavoriteStationsIds() -> [String] {
    self.defaults.array(forKey: Const.favoriteStationsId) as? [String] ?? []
  }

  func addFavoriteStation(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return }

    stations.append(code)
    self.defaults.set(stations, forKey: Const.favoriteStationsId)
  }

  func removeFavoriteStations(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard stations.contains(code) else { return }

    stations.removeAll { $0 == code }
    self.defaults.set(stations, forKey: Const.favoriteStationsId)
  }

  func isFavoriteStation(from code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }

  func getNumberOfFavoriteStations() -> Int {
    self.getFavoriteStationsIds().count
  }

  private struct Const {
    static let favoriteStationsId = "favoriteStationsCode"
  }
}
