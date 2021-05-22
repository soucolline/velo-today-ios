//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

class MapService {
  
  private let apiWorker: APIWorker
  private let urlFactory: URLFactory
  
  init(apiWorker: APIWorker, urlFactory: URLFactory) {
    self.apiWorker = apiWorker
    self.urlFactory = urlFactory
  }

  func fetchPins() -> AnyPublisher<[Station], APIError> {
    let url = self.urlFactory.createFetchPinsUrl()

    return self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:])
      .map { response in
        response.records.map { $0.station }
      }
      .eraseToAnyPublisher()
  }

  func fetchAllStations(from ids: [String]) -> AnyPublisher<[Station], APIError> {
    let publishers: [AnyPublisher<Station, APIError>] = ids.map { id -> AnyPublisher<Station, APIError> in
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
