//
//  ApiClient.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Models

public struct ApiClient: Sendable {
  public var fetchAllStations: @Sendable () async throws -> [Station]
}

public protocol ApiClientProtocol: Sendable {
  func fetchAllStations() async throws -> [Station]
}

public final class ApiClientImpl: ApiClientProtocol {
  public func fetchAllStations() async throws -> [Station] {
    let locationURL = URL(string: "https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_information.json")!
    let bikesURL = URL(string: "https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_status.json")!
    
    async let (locationData, _) = try await URLSession.shared.data(from: locationURL)
    async let (bikesData, _) = try await URLSession.shared.data(from: bikesURL)
    
    let locationResponseEnvelope = try await JSONDecoder().decode(FetchStationLocationResponseRoot.self, from: locationData)
    let stationsResponseEnvelope = try await JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: bikesData)
    
    // Merge result of location + station to make an array of station objects
    let stations = stationsResponseEnvelope.data.stations.map { stationResponse -> Station? in
      let correspondingLocationResponse = locationResponseEnvelope.data.stations.filter {
        stationResponse.stationCode == $0.stationCode
      }.first
      
      guard let locationResponse = correspondingLocationResponse else { return nil }
      
      let station = Station(
        freeDocks: stationResponse.freeDocks,
        code: stationResponse.stationCode,
        name: locationResponse.name,
        totalDocks: locationResponse.capacity,
        freeBikes: stationResponse.freeBikes,
        freeMechanicalBikes: stationResponse.freeMechanicalBikes ?? -1,
        freeElectricBikes: stationResponse.freeElectricBikes ?? -1,
        geolocation: [locationResponse.lat, locationResponse.lon]
      )
      
      return station
    }
    .compactMap { $0 }

    return stations
  }
}
