//
//  VelibInteractor.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Promises
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
    MapService().fetchPins()
      .then(self.presenter.fetchPinsSuccess)
      .catch(self.presenter.failure)
  }
  
  func fetchAllStations(favoriteStations: [FavoriteStation]) {
    MapService().fetchAllStations(favoriteStations: favoriteStations)
      .then(self.presenter.fetchAllStationsSuccess)
      .catch(self.presenter.failure)
  }
  
  func addFavorite(station: Station) {
    CoreDataService().addFavorite(station: station)
      .then(self.presenter.addFavoriteSuccess)
      .catch(self.presenter.failure)
  }
  
  func removeFavorite(station: Station) {
    CoreDataService().removeFavorite(station: station)
      .then(self.presenter.removeFavoriteSuccess)
      .catch(self.presenter.failure)
  }
  
}
