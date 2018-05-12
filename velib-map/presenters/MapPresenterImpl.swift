//
//  MapPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol MapViewDelegate: class, Loadable {
  func onCleanMap(with stations: [Station])
  
  func onFetchStationsSuccess(stations: [Station])
  func onFetchStationsErrorNotFound()
  func onFetchStationsErrorServerError()
  func onFetchStationsErrorCouldNotDecodeData()
}

protocol MapPresenter {
  var currentStation: Station? { get set }
  func reloadPins()
  func getMapStyle() -> String
}

class MapPresenterImpl: MapPresenter {
  
  private weak var delegate: MapViewDelegate?
  private let service: MapService
  
  var stations = [Station]()
  var currentStation: Station?
  
  init(delegate: MapViewDelegate, service: MapService) {
    self.delegate = delegate
    self.service = service
  }
  
  func reloadPins() {
    self.delegate?.onShowLoading()
    self.delegate?.onCleanMap(with: self.stations)
    
    self.stations.removeAll()
    
    self.service.fetchPins().then { stations in
      self.stations = stations
      self.delegate?.onFetchStationsSuccess(stations: self.stations)
      self.delegate?.onDismissLoading()
    }.catch { error in
      self.delegate?.onDismissLoading()
      
      switch error {
      case APIError.notFound:
        self.delegate?.onFetchStationsErrorNotFound()
      case APIError.internalServerError, APIError.unknown:
        self.delegate?.onFetchStationsErrorServerError()
      case APIError.couldNotDecodeData:
        self.delegate?.onFetchStationsErrorCouldNotDecodeData()
      default: ()
      }
    }
  }
  
  func getMapStyle() -> String {
    let defaults = UserDefaults.standard
    return (defaults.value(forKey: "mapStyle") as? String) ?? ""
  }
  
}
