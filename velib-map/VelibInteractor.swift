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
    var stations = [Station]()
    
    let response = Just.get(Api.allStationsFrom(.paris).url)
    if response.ok {
      let responseJSON = JSON(response.json as Any)
      let _ = responseJSON.map{ $0.1 }.map {
        let station = Mapper.mapStations(newsJSON: $0)
        stations.append(station)
      }
      self.presenter.fetchPinsSuccess(stations: stations)
    } else {
      self.presenter.failure(error: "Impossible de recuperer les informations des stations")
    }
  }
  
  func fetchAllStations(favoriteStations: [FavoriteStation]) {
    var fetchedStations = [Station]()
    let _ = favoriteStations.map {
      let r = Just.get(Api.stationFrom($0.number).url)
      if r.ok {
        let responseJSON = JSON(r.json as Any)
        let station = Mapper.mapStations(newsJSON: responseJSON)
        fetchedStations.append(station)
      } else {
        self.presenter.failure(error: "Could not fetch station")
      }
    }
    
    self.presenter.fetchAllStationsSuccess(stations: fetchedStations)
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
