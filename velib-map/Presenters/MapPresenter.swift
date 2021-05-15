//
//  MapPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

protocol MapView: AnyObject, Loadable {
  func onCleanMap(with stations: [Station])
  
  func onFetchStationsSuccess(stations: [Station])
  func onFetchStationsErrorNotFound()
  func onFetchStationsErrorServerError()
  func onFetchStationsErrorCouldNotDecodeData()
}

protocol MapPresenter {
  var currentStation: Station? { get set }
  
  func attach(_ view: MapView)
  func reloadPins()
  func getMapStyle() -> MapStyle
  func getCurrentStation() -> Station?
}

class MapPresenterImpl: MapPresenter {
  
  private weak var view: MapView?
  private let service: MapService
  private let repository: PreferencesRepository
  private let networkScheduler: NetworkScheduler
  
  var stations: [Station] = [Station]()
  var currentStation: Station?
  private var cancellable: AnyCancellable?
  
  init(service: MapService, repository: PreferencesRepository, networkScheduler: NetworkScheduler) {
    self.service = service
    self.repository = repository
    self.networkScheduler = networkScheduler
  }
  
  func attach(_ view: MapView) {
    self.view = view
  }
  
  func reloadPins() {
    self.view?.onShowLoading()
    self.view?.onCleanMap(with: self.stations)
    
    self.stations.removeAll()

    self.cancellable = self.service.fetchPins()
      .subscribe(on: self.networkScheduler.concurent)
      .receive(on: self.networkScheduler.main)
      .sink(receiveCompletion: { completion in
        switch completion {
          case .finished: break
          case .failure(let error):
            self.view?.onDismissLoading()
            switch error {
            case APIError.notFound:
              self.view?.onFetchStationsErrorNotFound()
            case APIError.internalServerError, APIError.unknown:
              self.view?.onFetchStationsErrorServerError()
            case APIError.couldNotDecodeJSON:
              self.view?.onFetchStationsErrorCouldNotDecodeData()
            default: ()
            }
        }
      }, receiveValue: { stations in
        self.stations = stations
        self.view?.onFetchStationsSuccess(stations: self.stations)
        self.view?.onDismissLoading()
      })
  }
  
  func getMapStyle() -> MapStyle {
    self.repository.getMapStyle()
  }
  
  func getCurrentStation() -> Station? {
    self.currentStation
  }
  
}
