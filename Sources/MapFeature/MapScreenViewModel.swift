//
//  MapScreenViewModel.swift
//  velo-today-ios
//
//  Created by Thomas Guilleminot on 07/06/2025.
//

import Dependencies
import Perception
import Sharing
import DetailsFeature
import MapKit
import Models
import ApiClient

@Perceptible
@MainActor
public class MapScreenViewModel {
  @PerceptionIgnored
  @Shared(.appStorage("mapStyle")) var mapStyleUserDefaults: String = "normalStyle"
  @PerceptionIgnored
  @Shared(.inMemory("stations")) public var stations: [Station] = []
  @PerceptionIgnored
  @Dependency(\.apiClientProtocol) public var apiClient
  
  public enum Destination {
    case details(StationMarker)
  }
  
  public var hasAlreadyLoadedStations: Bool
  public var errorText: String
  public var mapStyle: MapStyle
  public var shouldShowLoader: Bool
  public var shouldShowError: Bool
  public var coordinateRegion: MKCoordinateRegion
  
  public var destination: Destination?
  
  public init(
    hasAlreadyLoadedStations: Bool = false,
    errorText: String = "Impossible de charger les données de certaines stations",
    mapStyle: MapStyle = .normal,
    shouldShowLoader: Bool = false,
    shouldShowError: Bool = false,
    coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
      latitudinalMeters: 1000 * 2.0,
      longitudinalMeters: 1000 * 2.0)
  ) {
    self.hasAlreadyLoadedStations = hasAlreadyLoadedStations
    self.errorText = errorText
    self.mapStyle = mapStyle
    self.shouldShowLoader = shouldShowLoader
    self.shouldShowError = shouldShowError
    self.coordinateRegion = coordinateRegion
  }
  
  public func fetchAllStations() async {
    shouldShowLoader = true
    
    do {
      let stations = try await apiClient.fetchAllStations()
      self.$stations.withLock {
        $0 = stations
      }
      hasAlreadyLoadedStations = true
      shouldShowLoader = false
    } catch {
      hasAlreadyLoadedStations = true
      shouldShowError = true
      shouldShowLoader = false
    }
  }
  
  public func getMapStyle() {
    mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
  }
  
  public func hideError() {
    shouldShowError = false
  }
  
  public func stationPinTapped(station: StationMarker) {
    destination = .details(station)
  }
  
  public func hideDetails() {
    destination = nil
  }
}
