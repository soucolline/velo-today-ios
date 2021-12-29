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
  func onCleanMap(with stations: [UIStation])
  
  func onFetchStationsSuccess(stations: [UIStation])
  func onFetchStationsErrorNotFound()
  func onFetchStationsErrorServerError()
  func onFetchStationsErrorCouldNotDecodeData()
}

protocol MapPresenter {
  var currentStation: UIStation? { get set }
  
  func attach(_ view: MapView)
  func reloadPins()
  func getMapStyleForDisplay() -> MapStyle
  func getCurrentStation() -> UIStation?
}

class MapPresenterImpl: MapPresenter {
  private let getAllStations: GetAllStationsUseCase
  private let getMapStyle: GetMapStyleUseCase
  private let networkScheduler: NetworkScheduler

  private weak var view: MapView?
  private var cancellable: AnyCancellable?

  var stations: [UIStation] = [UIStation]()
  var currentStation: UIStation?
  
  init(
    getAllStations: GetAllStationsUseCase,
    getMapStyle: GetMapStyleUseCase,
    networkScheduler: NetworkScheduler
  ) {
    self.getAllStations = getAllStations
    self.getMapStyle = getMapStyle
    self.networkScheduler = networkScheduler
  }
  
  func attach(_ view: MapView) {
    self.view = view
  }
  
  func reloadPins() {
    self.view?.onShowLoading()
    self.view?.onCleanMap(with: self.stations)
    
    self.stations.removeAll()

    self.cancellable = self.getAllStations.invoke()
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
  
  func getMapStyleForDisplay() -> MapStyle {
    self.getMapStyle.invoke()
  }
  
  func getCurrentStation() -> UIStation? {
    self.currentStation
  }
  
}
