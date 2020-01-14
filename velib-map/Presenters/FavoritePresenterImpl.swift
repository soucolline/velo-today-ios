//
//  FavoritePresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

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
  private let favoriteRepository: FavoriteRepository
  
  private var stations: [Station]?
  
  init(with service: MapService, favoriteRepository: FavoriteRepository) {
    self.service = service
    self.favoriteRepository = favoriteRepository
  }
  
  func setView(view: FavoriteViewDeletage) {
    self.delegate = view
  }
  
  func fetchFavoriteStations() {
    self.delegate?.onShowLoading()

    let favoriteStationsIds = self.favoriteRepository.getFavoriteStationsIds()

    guard !favoriteStationsIds.isEmpty else {
      self.stations = nil
      self.delegate?.onDismissLoading()
      self.delegate?.onFetchStationsEmptyError()
      return
    }

    self.service.fetchAllStations(from: favoriteStationsIds).then { stations in
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
