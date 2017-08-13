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

protocol IVelibInteractor {
  func fetchPins()
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
  
}
