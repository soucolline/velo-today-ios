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

class CoreDataService {
  
  private let dataStack: DataStack
  
  init(with dataStack: DataStack) {
    self.dataStack = dataStack
  }
  
  func addFavorite(station: Station) -> Promise<FavoriteStation> {
    return Promise<FavoriteStation> { fulfill, reject in
      self.dataStack.perform(asynchronous: { transaction -> FavoriteStation in
        let favStation = transaction.create(Into<FavoriteStation>())
        favStation.number = Int32(station.code) ?? 0
        favStation.availableBikes = Int16(station.freeBikes)
        favStation.availableBikeStands = Int16(station.freeDocks)
        favStation.name = station.name
        favStation.address = station.name
        return favStation
      }, success: { favStation in
        fulfill(favStation)
      }, failure: { _ in
        reject(APIError.notFound)
      })
    }
  }
  
  func removeFavorite(station: Station) -> Promise<Int> {
    return Promise<Int> { fulfill, reject in
      self.dataStack.perform(asynchronous: { transaction -> Int? in
        try? transaction.deleteAll(From<FavoriteStation>(), Where<FavoriteStation>("number", isEqualTo: station.code))
      }, success: { result in
        if let result = result {
          fulfill(result)
        } else {
          fulfill(0)
        }
      }, failure: { _ in
        reject(APIError.notFound)
      })
    }
  }
  
}
