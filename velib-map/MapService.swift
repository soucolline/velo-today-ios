//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Alamofire
import Promises

class MapService {
  
  func fetchPins() -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var stations = [Station]()
      
      Alamofire.request(K.Api.baseUrl).validate().responseJSON { response in
        guard response.result.isSuccess else { return reject(APIError.notFound) }
        guard let data = response.data else {
          reject(APIError.internalServerError)
          return
        }
        
        let decoder = JSONDecoder()
        
        do {
          let dataRoot = try decoder.decode(FetchStationObjectResponseRoot.self, from: data)
          _ = dataRoot.records.map {
            stations.append($0.station)
          }
          
          fulfill(stations)
        } catch _ {
          reject(APIError.couldNotDecodeData)
        }
      }
    }
  }
    
  func fetchAllStations(favoriteStations: [FavoriteStation]) -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var fetchedStations = [Station]()
      
      _ = favoriteStations.map { station in
        let url = K.Api.baseUrl + K.Api.stationQuery + "\(station.number)"
        
        Alamofire.request(url).validate().responseJSON { response in
          guard response.result.isSuccess else { return reject(APIError.notFound) }
          guard let data = response.data else {
            reject(APIError.internalServerError)
            return
          }
          
          let decoder = JSONDecoder()
          
          do {
            let dataRoot = try decoder.decode(FetchStationObjectResponseRoot.self, from: data)
            _ = dataRoot.records.map {
              fetchedStations.append($0.station)
            }
            
            fulfill(fetchedStations)
          } catch _ {
            reject(APIError.couldNotDecodeData)
          }
        }
      }
    }
  }
  
}
