//
//  DetailsScreenViewModel.swift
//  velo-today-ios
//
//  Created by Thomas Guilleminot on 07/06/2025.
//

import Dependencies
import MapKit
import Models
import UserDefaultsClient

@Observable
public final class DetailsScreenViewModel {
  public var station: StationMarker
  public var title: String
  public var isFavoriteStation = false
  public var stationLocation: MKCoordinateRegion
  
  @ObservationIgnored
  @Dependency(\.userDefaultsRepository) public var userDefaultsRepository
  
  public init(station: StationMarker, isFavoriteStation: Bool = false) {
    self.station = station
    self.title = station.name
    self.stationLocation = MKCoordinateRegion(
      center: station.coordinate,
      latitudinalMeters: 200,
      longitudinalMeters: 200
    )
    
    self.isFavoriteStation = self.userDefaultsRepository.isFavoriteStation(code: station.code)
  }
  
  public func favoriteButtonTapped() {
    if isFavoriteStation {
      isFavoriteStation = false
      self.userDefaultsRepository.removeFavoriteStations(for: station.code)
    } else {
      isFavoriteStation = true
      self.userDefaultsRepository.addFavoriteStation(for: station.code)
    }
  }
}
