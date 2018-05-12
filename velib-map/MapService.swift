//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Promises

class MapService {
  
  func fetchPins() -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var stations = [Station]()
      
      Alamofire.request(K.Api.baseUrl).validate().responseJSON { response in
        guard response.result.isSuccess else { return reject(APIError.notFound) }
        
        let responseJSON = JSON(response.value as Any)["records"]
        _ = responseJSON.map { $0.1 }.map {
        let station = Mapper.mapStations(newsJSON: $0)
          stations.append(station)
        }
        
        fulfill(stations)
      }
    }
  }
    
  func fetchAllStations(favoriteStations: [FavoriteStation]) -> Promise<[Station]> {
    return Promise<[Station]> { fulfill, reject in
      var fetchedStations = [Station]()
      
      _ = favoriteStations.map { station in
        Alamofire.request(Api.stationFrom(station.number).url).validate().responseJSON { response in
          guard response.result.isSuccess
            else { return reject(APIError.notFound) }
          
          let responseJSON = JSON(response.value as Any)["records"]
          
          if let json = responseJSON.first?.1 {
            let station = Mapper.mapStations(newsJSON: json)
            fetchedStations.append(station)
            
            if fetchedStations.count == favoriteStations.count {
              fulfill(fetchedStations)
            }
          } else {
            reject(APIError.notFound)
          }
        }
      }
    }
  }
  
}
