//
//  StationRepository.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol StationRepository {
  func fetchPins() async throws -> [DomainStation]
  func fetchAllStations(from ids: [String]) async throws -> [DomainStation]

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

  func fetchPins() async throws -> [DomainStation] {
    try await stationRemoteDataSource.fetchPins().map { try $0.toDomain() }
  }

  func fetchAllStations(from ids: [String]) async throws -> [DomainStation] {
    try await stationRemoteDataSource.fetchAllStations(from: ids)
      .map { try $0.toDomain() }
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
