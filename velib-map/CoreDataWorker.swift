//
//  CoreDataWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Future
import CoreStore

class CoreDataWorker {
  
  static func addFavorite(station: Station) -> Future<FavoriteStation> {
    return Promise { promise in
      CoreStore.perform(asynchronous: { transaction -> FavoriteStation in
        let favStation = transaction.create(Into<FavoriteStation>())
        favStation.number = Int32(station.number!)
        favStation.availableBikes = Int16(station.availableBikes!)
        favStation.availableBikeStands = Int16(station.availableBikeStands!)
        favStation.name = station.name
        favStation.address = station.address
        return favStation
      }, success: { favStation in
        promise.resolve(favStation)
      }, failure: { error in
        promise.reject(error.localizedDescription)
      })
    }
  }
  
  static func removeFavorite(station: Station) -> Future<Void> {
    return Promise { promise in
      CoreStore.perform(asynchronous: { transaction in
        transaction.deleteAll(From<FavoriteStation>(), Where("number", isEqualTo: station.number))
      }, success: {
        promise.resolve()
      }, failure: { error in
        promise.reject(error.localizedDescription)
      })
    }
  }
  
}
