//
//  VelibInteractor.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
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
    CoreDataWorker.addFavorite(station: station)
      .then(self.presenter.addFavoriteSuccess)
      .fail(self.presenter.failure)
  }
  
  func removeFavorite(station: Station) {
    CoreDataWorker.removeFavorite(station: station)
      .then(self.presenter.removeFavoriteSuccess)
      .fail(self.presenter.failure)
  }
  
}
