//
//  CoreDataWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Promises
import CoreStore

class CoreDataWorker {
  
  static func addFavorite(station: Station) -> Promise<FavoriteStation> {
    return Promise<FavoriteStation> { fulfill, reject in
      CoreStore.perform(asynchronous: { transaction -> FavoriteStation in
        let favStation = transaction.create(Into<FavoriteStation>())
        favStation.number = Int32(station.stationId!)
        favStation.availableBikes = Int16(station.numbikesavailable!)
        favStation.availableBikeStands = Int16(station.numdocksavailable!)
        favStation.name = station.name
        favStation.address = station.address
        return favStation
      }, success: { favStation in
        fulfill(favStation)
      }, failure: { error in
        reject(APIError.notFound)
      })
    }
  }
  
  static func removeFavorite(station: Station) -> Promise<Int> {
    return Promise<Int> { fulfill, reject in
      CoreStore.perform(asynchronous: { transaction -> Int? in
        transaction.deleteAll(From<FavoriteStation>(), Where<FavoriteStation>("number", isEqualTo: station.stationId))
      }, success: { result in
        if let result = result {
          fulfill(result)
        } else{
          fulfill(0)
        }
      }, failure: { error in
        reject(APIError.notFound)
      })
    }
  }
  
}
