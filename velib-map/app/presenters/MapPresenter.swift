//
//  MapPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

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

  private weak var view: MapView?

  var stations: [UIStation] = [UIStation]()
  var currentStation: UIStation?
  
  init(
    getAllStations: GetAllStationsUseCase,
    getMapStyle: GetMapStyleUseCase
  ) {
    self.getAllStations = getAllStations
    self.getMapStyle = getMapStyle
  }
  
  func attach(_ view: MapView) {
    self.view = view
  }
  
  func reloadPins() {
    self.view?.onShowLoading()
    self.view?.onCleanMap(with: self.stations)
    
    self.stations.removeAll()

    Task {
      do {
        self.stations = try await getAllStations.invoke()
        self.view?.onFetchStationsSuccess(stations: self.stations)
        self.view?.onDismissLoading()
      } catch let error {
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
    }
  }
  
  func getMapStyleForDisplay() -> MapStyle {
    self.getMapStyle.invoke()
  }
  
  func getCurrentStation() -> UIStation? {
    self.currentStation
  }
  
}
