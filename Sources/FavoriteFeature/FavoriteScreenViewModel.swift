//
//  FavoriteScreenViewModel.swift
//  velo-today-ios
//
//  Created by Thomas Guilleminot on 07/06/2025.
//

import ApiClient
import Dependencies
import Sharing
import Perception
import DetailsFeature
import Foundation
import UserDefaultsClient
import Models

@Perceptible
public final class FavoriteScreenViewModel {
  @PerceptionIgnored
  @Shared(.inMemory("stations")) public var stations: [Station] = []
  
  @PerceptionIgnored
  @Dependency(\.userDefaultsRepository) public var userDefaultsRepository
  @PerceptionIgnored
  @Dependency(\.apiClient) public var apiClient
  @PerceptionIgnored
  @Dependency(\.mainQueue) public var mainQueue
  
  public var favoriteStations: [Station] = []
  public var isFetchStationRequestInFlight: Bool
  public var errorText: String
  public var shouldShowError: Bool
  public var shouldShowEmptyView: Bool
  
  public init(
    stations: [Station] = [],
    isFetchStationRequestInFlight: Bool = false,
    errorText: String = "Impossible de charger les données de certaines stations",
    shouldShowError: Bool = false,
    shouldShowEmptyView: Bool = false
  ) {
    self.isFetchStationRequestInFlight = isFetchStationRequestInFlight
    self.errorText = errorText
    self.shouldShowError = shouldShowError
    self.shouldShowEmptyView = shouldShowEmptyView
  }
  
  public func onAppear() {
    let stationsIds = self.userDefaultsRepository.array(for: "favoriteStationsCode")
    
    guard !stationsIds.isEmpty else {
      favoriteStations = []
      shouldShowEmptyView = true
      return
    }
    
    favoriteStations = stations.filter { stationsIds.contains($0.code) }
    shouldShowEmptyView = favoriteStations.isEmpty
  }
  
  public func fetchFavoriteStations() async {
    favoriteStations = []
    isFetchStationRequestInFlight = true
    shouldShowEmptyView = false
    
    do {
      let stationResponse = try await apiClient.fetchAllStations()
      let stationsIds = self.userDefaultsRepository.array(for: "favoriteStationsCode")
      
      isFetchStationRequestInFlight = false
      
      guard !stationsIds.isEmpty else {
        shouldShowEmptyView = true
        return
      }
      
      $stations.withLock { $0 = stationResponse }
      favoriteStations = stationResponse.filter { stationsIds.contains($0.code) }
      isFetchStationRequestInFlight = false
    } catch {
      isFetchStationRequestInFlight = false
      shouldShowError = true

      try? await self.mainQueue.sleep(for: 2)
      
      hideError()
    }
    
  }
  
  public func stationTapped(station: Station) {
    
  }
  
  private func hideError() {
    shouldShowError = false
  }
}
