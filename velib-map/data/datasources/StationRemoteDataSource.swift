//
//  StationRemoteDataSource.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Moya

protocol StationRemoteDataSource {
  func fetchPins() async throws -> [StationResponse]
  func fetchAllStations(from ids: [String]) async throws -> [StationResponse]
}

class StationRemoteDataSourceImpl: StationRemoteDataSource {
  private let provider: MoyaProvider<StationRouter>

  init(provider: MoyaProvider<StationRouter>) {
    self.provider = provider
  }

  func fetchPins() async throws -> [StationResponse] {
    let response = try await provider.getAsync(route: StationRouter.getAllStations, typeOf: FetchStationObjectResponseRoot.self)

    return response.records.map { $0.station }
  }

  func fetchAllStations(from ids: [String]) async throws -> [StationResponse] {
    var stations: [StationResponse] = []

    for id in ids {
      let response = try await provider.getAsync(route: StationRouter.getSpecificStation(id: id), typeOf: FetchStationObjectResponseRoot.self)
      if let stationResponse = response.records.first?.station {
        stations.append(stationResponse)
      }
    }

    return stations
  }
}
