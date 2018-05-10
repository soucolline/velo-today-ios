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
        favStation.number = Int32(station.number!)
        favStation.availableBikes = Int16(station.availableBikes!)
        favStation.availableBikeStands = Int16(station.availableBikeStands!)
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
  
  static func removeFavorite(station: Station) -> Promise<Int?> {
    return Promise<Int?> { fulfill, reject in
      CoreStore.perform(asynchronous: { transaction -> Int? in
        transaction.deleteAll(From<FavoriteStation>().where(\.number > 30))
      }, success: { result in
        fulfill(0)
      }, failure: { error in
        reject(APIError.notFound)
      })
    }
  }
  
}
