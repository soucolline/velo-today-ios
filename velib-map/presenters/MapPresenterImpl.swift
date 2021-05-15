//
//  MapPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

protocol MapViewDelegate: AnyObject, Loadable {
  func onCleanMap(with stations: [Station])
  
  func onFetchStationsSuccess(stations: [Station])
  func onFetchStationsErrorNotFound()
  func onFetchStationsErrorServerError()
  func onFetchStationsErrorCouldNotDecodeData()
}

protocol MapPresenter {
  var currentStation: Station? { get set }
  
  func setView(view: MapViewDelegate)
  func reloadPins()
  func getMapStyle() -> MapStyle
  func getCurrentStation() -> Station?
}

class MapPresenterImpl: MapPresenter {
  
  private weak var delegate: MapViewDelegate?
  private let service: MapService
  private let repository: PreferencesRepository
  
  var stations: [Station] = [Station]()
  var currentStation: Station?
  private var cancellable: AnyCancellable?
  
  init(service: MapService, repository: PreferencesRepository) {
    self.service = service
    self.repository = repository
  }
  
  func setView(view: MapViewDelegate) {
    self.delegate = view
  }
  
  func reloadPins() {
    self.delegate?.onShowLoading()
    self.delegate?.onCleanMap(with: self.stations)
    
    self.stations.removeAll()

    self.cancellable = self.service.fetchPins()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
          case .finished: break
          case .failure(let error):
            self.delegate?.onDismissLoading()
            switch error {
            case APIError.notFound:
              self.delegate?.onFetchStationsErrorNotFound()
            case APIError.internalServerError, APIError.unknown:
              self.delegate?.onFetchStationsErrorServerError()
            case APIError.couldNotDecodeJSON:
              self.delegate?.onFetchStationsErrorCouldNotDecodeData()
            default: ()
            }
        }
      }, receiveValue: { stations in
        self.stations = stations
        self.delegate?.onFetchStationsSuccess(stations: self.stations)
        self.delegate?.onDismissLoading()
      })
  }
  
  func getMapStyle() -> MapStyle {
    self.repository.getMapStyle()
  }
  
  func getCurrentStation() -> Station? {
    self.currentStation
  }
  
}
