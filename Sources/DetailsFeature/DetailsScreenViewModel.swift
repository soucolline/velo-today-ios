//
//  DetailsScreenViewModel.swift
//  velo-today-ios
//
//  Created by Thomas Guilleminot on 07/06/2025.
//

import Dependencies
import Perception
import MapKit
import Models
import UserDefaultsClient

@Perceptible
public final class DetailsScreenViewModel {
  public var station: StationMarker
  public var title: String
  public var isFavoriteStation: Bool
  public var stationLocation: MKCoordinateRegion
  
  @PerceptionIgnored
  @Dependency(\.userDefaultsRepository) public var userDefaultsRepository
  
  public init(
    station: StationMarker = StationMarker(
      freeDocks: 1,
      code: "123",
      name: "Test name",
      totalDocks: 4,
      freeBikes: 5,
      freeMechanicalBikes: 6,
      freeElectricBikes: 7,
      geolocation: [20, 30]
    ),
    title: String = "",
    isFavoriteStation: Bool = false,
    stationLocation: MKCoordinateRegion = MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: 48.866667,
        longitude: 2.333333),
      latitudinalMeters: 2000,
      longitudinalMeters: 2000
    )
  ) {
    self.station = station
    self.title = title
    self.isFavoriteStation = isFavoriteStation
    self.stationLocation = stationLocation
  }
  
  public func onAppear() {
    title = station.name
    stationLocation = MKCoordinateRegion(
      center: station.coordinate,
      latitudinalMeters: 200,
      longitudinalMeters: 200
    )
    
    isFavoriteStation = self.userDefaultsRepository.isFavoriteStation(code: station.code)
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
