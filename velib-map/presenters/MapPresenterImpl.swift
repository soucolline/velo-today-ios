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
  func getMapStyle() -> MapStyle
  func getCurrentStation() -> Station?
}

class MapPresenterImpl: MapPresenter {
  
  private weak var delegate: MapViewDelegate?
  private let service: MapService
  private let repository: PreferencesRepository
  
  var stations = [Station]()
  var currentStation: Station?
  
  init(delegate: MapViewDelegate, service: MapService, repository: PreferencesRepository) {
    self.delegate = delegate
    self.service = service
    self.repository = repository
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
  
  func getMapStyle() -> MapStyle {
    return self.repository.getMapStyle()
  }
  
  func getCurrentStation() -> Station? {
    return self.currentStation
  }
  
}
