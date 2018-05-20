//
//  FavoritePresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreStore

protocol FavoriteViewDeletage: class, Loadable {
  func onFetchStationsSuccess()
  func onFetchStationsEmptyError()
  func onFetchStationsError()
}

protocol FavoritePresenter {
  func fetchFavoriteStations()
  func getStation(at index: Int) -> Station?
  func getStationsCount() -> Int
}

class FavoritePresenterImpl: FavoritePresenter {
  
  private weak var delegate: FavoriteViewDeletage?
  private let service: MapService
  
  private var stations: [Station]?
  
  init(delegate: FavoriteViewDeletage, service: MapService) {
    self.delegate = delegate
    self.service = service
  }
  
  func fetchFavoriteStations() {
    self.delegate?.onShowLoading()
    
    let favoriteStations = CoreStore.fetchAll(From<FavoriteStation>()) ?? []
    
    guard !favoriteStations.isEmpty else {
      self.delegate?.onDismissLoading()
      self.delegate?.onFetchStationsEmptyError()
      return
    }
    
    self.service.fetchAllStations(favoriteStations: favoriteStations).then { stations in
      self.stations = stations.sorted { return $0.stationId > $1.stationId }
      self.delegate?.onFetchStationsSuccess()
      self.delegate?.onDismissLoading()
    }.catch { _ in
      self.delegate?.onDismissLoading()
      self.delegate?.onFetchStationsError()
    }
  }
  
  func getStation(at index: Int) -> Station? {
    return self.stations?[index]
  }
  
  func getStationsCount() -> Int {
    return self.stations?.count ?? 0
  }
  
}
