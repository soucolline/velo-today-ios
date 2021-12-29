//
//  StationRepository.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

protocol StationRepository {
  func fetchPins() -> AnyPublisher<[Station], APIError>
  func fetchAllStations(from ids: [String]) -> AnyPublisher<[Station], APIError>

  func getFavoriteStationsIds() -> [String]
  func addFavoriteStation(for code: String)
  func removeFavoriteStations(for code: String)
  func isFavoriteStation(from code: String) -> Bool
  func getNumberOfFavoriteStations() -> Int
}

class StationRepositoryImpl: StationRepository {
  private let stationRemoteDataSource: StationRemoteDataSource
  private let favoriteLocalDataSource: FavoriteLocalDataSource

  init(
    stationRemoteDataSource: StationRemoteDataSource,
    favoriteLocalDataSource: FavoriteLocalDataSource
  ) {
    self.stationRemoteDataSource = stationRemoteDataSource
    self.favoriteLocalDataSource = favoriteLocalDataSource
  }

  func fetchPins() -> AnyPublisher<[Station], APIError> {
    stationRemoteDataSource.fetchPins()
  }

  func fetchAllStations(from ids: [String]) -> AnyPublisher<[Station], APIError> {
    stationRemoteDataSource.fetchAllStations(from: ids)
  }

  func getFavoriteStationsIds() -> [String] {
    favoriteLocalDataSource.getFavoriteStationsIds()
  }

  func addFavoriteStation(for code: String) {
    favoriteLocalDataSource.addFavoriteStation(for: code)
  }

  func removeFavoriteStations(for code: String) {
    favoriteLocalDataSource.removeFavoriteStations(for: code)
  }

  func isFavoriteStation(from code: String) -> Bool {
    favoriteLocalDataSource.isFavoriteStation(from: code)
  }

  func getNumberOfFavoriteStations() -> Int {
    favoriteLocalDataSource.getNumberOfFavoriteStations()
  }
}
