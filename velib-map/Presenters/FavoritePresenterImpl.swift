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
  func setView(view: FavoriteViewDeletage)
  
  func fetchFavoriteStations()
  func getStation(at index: Int) -> Station?
  func getStationsCount() -> Int
}

class FavoritePresenterImpl: FavoritePresenter {
  
  private weak var delegate: FavoriteViewDeletage?
  private let service: MapService
  private let dataStack: DataStack
  
  private var stations: [Station]?
  
  init(with service: MapService, dataStack: DataStack) {
    self.service = service
    self.dataStack = dataStack
  }
  
  func setView(view: FavoriteViewDeletage) {
    self.delegate = view
  }
  
  func fetchFavoriteStations() {
    self.delegate?.onShowLoading()
    
    guard let favoriteStations = try? self.dataStack.fetchAll(From<FavoriteStation>()), !favoriteStations.isEmpty else {
      self.stations = nil
      self.delegate?.onDismissLoading()
      self.delegate?.onFetchStationsEmptyError()
      return
    }
    
    self.service.fetchAllStations(favoriteStations: favoriteStations).then { stations in
      self.stations = stations.sorted { return $0.code > $1.code }
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
