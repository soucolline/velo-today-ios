//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation

class MapService {
  
  private let apiWorker: APIWorker
  
  init(with apiWorker: APIWorker) {
    self.apiWorker = apiWorker
  }

  func fetchPins(completion: @escaping (Result<[Station], APIError>) -> Void) {
    var stations = [Station]()
    guard let url = URL(string: K.Api.baseUrl) else { return }

    self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:]) { result in
      switch result {
      case .success(let response):
        response.records.forEach { stations.append($0.station) }
        completion(.success(stations))
      case .failure(let error):
        completion(.failure(APIError.customError(error.localizedDescription)))
      }
    }
  }

  func fetchAllStations(from ids: [String], completion: @escaping (Result<[Station], APIError>) -> Void) {
    var fetchedStations = [Station]()

    ids.forEach { id in
      guard let url = URL(string: K.Api.baseUrl + K.Api.stationQuery + "\(id)") else { return }

      self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:]) { result in
        switch result {
        case .success(let response):
          response.records.forEach { fetchedStations.append($0.station) }

          if fetchedStations.count == ids.count {
            completion(.success(fetchedStations))
          }

        case .failure(let error):
          completion(.failure(APIError.customError(error.localizedDescription)))
        }
      }
    }
  }
  
}
