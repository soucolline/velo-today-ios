//
//  StationRemoteDataSource.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

protocol StationRemoteDataSource {
  func fetchPins() -> AnyPublisher<[StationResponse], APIError>
  func fetchAllStations(from ids: [String]) -> AnyPublisher<[StationResponse], APIError>
}

class StationRemoteDataSourceImpl: StationRemoteDataSource {
  private let apiWorker: APIWorker
  private let urlFactory: URLFactory

  init(apiWorker: APIWorker, urlFactory: URLFactory) {
    self.apiWorker = apiWorker
    self.urlFactory = urlFactory
  }

  func fetchPins() -> AnyPublisher<[StationResponse], APIError> {
    let url = self.urlFactory.createFetchPinsUrl()

    return self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:])
      .map { response in
        response.records.map { $0.station }
      }
      .eraseToAnyPublisher()
  }

  func fetchAllStations(from ids: [String]) -> AnyPublisher<[StationResponse], APIError> {
    let publishers: [AnyPublisher<StationResponse, APIError>] = ids.map { id -> AnyPublisher<StationResponse, APIError> in
      let url = self.urlFactory.createFetchStation(from: id)

      return self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:])
        .compactMap { response in
          response.records.first?.station
        }
        .eraseToAnyPublisher()
    }

    return Publishers.MergeMany(publishers)
      .collect()
      .eraseToAnyPublisher()
  }
}
