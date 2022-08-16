//
//  ApiClient.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct ApiClient {
  var fetchStation: @Sendable (String) async throws -> DomainStation
  var fetchAllStations: @Sendable () async throws -> [DomainStation]
}

extension ApiClient {
  static let live = Self(
    fetchStation: { id in
      // swiftlint:disable force_unwrapping
      let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=\(id)")!
      
      let (data, _) = try await URLSession.shared.data(from: url)
      let responseEnvelope = try JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data)
      
      guard let station = try responseEnvelope.records.map({ $0.station }).first?.toDomain() else {
        throw "No station"
      }
      
      return station
    },
    
    fetchAllStations: {
      // swiftlint:disable force_unwrapping
      let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&")!
      let (data, _) = try await URLSession.shared.data(from: url)
      let responseEnvelope = try JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data)
      let stations = try responseEnvelope.records.map({ try $0.station.toDomain()})
      
      return stations
    }
  )
}

extension String: Error {
  
}

extension String: LocalizedError {
  public var errorDescription: String? { self }
}

#if DEBUG
import XCTestDynamicOverlay

extension ApiClient {
  static let unimplemented = Self(
    fetchStation: XCTUnimplemented("\(Self.self) fetchStation unimplemented"),
    fetchAllStations: XCTUnimplemented("\(Self.self) fetchAllStations unimplemented")
  )
}
#endif
