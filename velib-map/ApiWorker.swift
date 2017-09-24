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
import Future


class ApiWorker {
  
  static func fetchPins() -> Future<[Station]> {
    return Promise { promise in
      var stations = [Station]()
      
      Alamofire.request(Api.allStationsFrom(.paris).url).validate().responseJSON { response in
        guard response.result.isSuccess
          else { return promise.reject("Could not fetch pins") }
        
        let responseJSON = JSON(response.value as Any)
        let _ = responseJSON.map{ $0.1 }.map {
        let station = Mapper.mapStations(newsJSON: $0)
          stations.append(station)
        }
        
        promise.resolve(stations)
      }
    }
  }
  
  static func fetchAllStations(favoriteStations: [FavoriteStation]) -> Future<[Station]> {
    return Promise { promise in
      var fetchedStations = [Station]()
      
      let _ = favoriteStations.map { station in
        Alamofire.request(Api.stationFrom(station.number).url).validate().responseJSON { response in
          guard response.result.isSuccess
            else { return promise.reject("Could not fetch Stations") }
          
          let responseJSON = JSON(response.value as Any)
          let station = Mapper.mapStations(newsJSON: responseJSON)
          fetchedStations.append(station)
          
          if fetchedStations.count == favoriteStations.count {
            promise.resolve(fetchedStations)
          }
        }
      }
    }
  }
  
}
