//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Promises

class MapService {
  
  private let apiWorker: APIWorker
  
  init(with apiWorker: APIWorker) {
    self.apiWorker = apiWorker
  }
  
  func fetchPins() -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var stations = [Station]()
      let url = URL(string: K.Api.baseUrl)!
      
      self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:]) { result in
        switch result {
        case .success(let response):
          _ = response.records.map { stations.append($0.station) }
          fulfill(stations)
        case .failure(let error):
          reject(APIError.customError(error.localizedDescription))
        }
      }
    }
  }

  func fetchAllStations(from ids: [String]) -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var fetchedStations = [Station]()

      _ = ids.map { id in
        let url = URL(string: K.Api.baseUrl + K.Api.stationQuery + "\(id)")!

        self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:]) { result in
          switch result {
          case .success(let response):
            _ = response.records.map { fetchedStations.append($0.station) }

            if fetchedStations.count == ids.count {
              fulfill(fetchedStations)
            }

          case .failure(let error):
            reject(APIError.customError(error.localizedDescription))
          }
        }
      }
    }
  }
  
}
