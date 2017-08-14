//
//  VelibInteractor.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Just
import SwiftyJSON
import CoreStore

protocol IVelibInteractor {
  func fetchPins()
  func fetchAllStations(favoriteStations: [FavoriteStation])
  func addFavorite(station: Station)
  func removeFavorite(station: Station)
}

class VelibInteractor: IVelibInteractor {
  
  let presenter = VelibPresenter()
  
  func fetchPins() {
    ApiWorker.fetchPins()
      .then(self.presenter.fetchPinsSuccess)
      .fail(self.presenter.failure)
  }
  
  func fetchAllStations(favoriteStations: [FavoriteStation]) {
    ApiWorker.fetchAllStations(favoriteStations: favoriteStations)
      .then(self.presenter.fetchAllStationsSuccess)
      .fail(self.presenter.failure)
  }
  
  func addFavorite(station: Station) {
    do {
      try CoreStore.perform(synchronous: { transaction in
        let favStation = transaction.create(Into<FavoriteStation>())
        favStation.number = Int32(station.number!)
        favStation.availableBikes = Int16(station.availableBikes!)
        favStation.availableBikeStands = Int16(station.availableBikeStands!)
        favStation.name = station.name
        favStation.address = station.address
        self.presenter.addFavoriteSuccess(favoriteStation: favStation)
      })
    } catch let e {
      self.presenter.failure(error: e.localizedDescription)
    }
  }
  
  func removeFavorite(station: Station) {
    let currentFav = CoreStore.fetchOne(From<FavoriteStation>(), Where("number", isEqualTo: station.number))
    
    do {
      try CoreStore.perform(synchronous: { transaction in
        transaction.delete(currentFav)
        self.presenter.removeFavoriteSuccess()
      })
    } catch let e {
      self.presenter.failure(error: e.localizedDescription)
    }
  }
  
}
