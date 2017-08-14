//
//  ApiWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Just
import SwiftyJSON
import Future


class ApiWorker {
  
  static func fetchPins() -> Future<[Station]> {
    return Promise { promise in
      var stations = [Station]()
      
      let response = Just.get(Api.allStationsFrom(.paris).url)
      if response.ok {
        let responseJSON = JSON(response.json as Any)
        let _ = responseJSON.map{ $0.1 }.map {
          let station = Mapper.mapStations(newsJSON: $0)
          stations.append(station)
        }
        
        promise.resolve(stations)
      }
      
      promise.reject("Could not fetch pins")
    }
  }
  
  static func fetchAllStations(favoriteStations: [FavoriteStation]) -> Future<[Station]> {
    return Promise { promise in
      var fetchedStations = [Station]()
      
      let _ = favoriteStations.map {
        let r = Just.get(Api.stationFrom($0.number).url)
        if r.ok {
          let responseJSON = JSON(r.json as Any)
          let station = Mapper.mapStations(newsJSON: responseJSON)
          fetchedStations.append(station)
        } else {
            promise.reject("Could not fetch Stations")
        }
      }
      
      promise.resolve(fetchedStations)
    }
  }
  
}
