//
//  FavoritePresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

protocol FavoriteView: AnyObject, Loadable {
  func onFetchStationsSuccess()
  func onFetchStationsEmptyError()
  func onFetchStationsError()
}

protocol FavoritePresenter {
  func attach(_ view: FavoriteView)
  
  func fetchFavoriteStations()
  func getStation(at index: Int) -> Station?
  func getStationsCount() -> Int
}

class FavoritePresenterImpl: FavoritePresenter {
  private let service: MapService
  private let favoriteRepository: FavoriteRepository
  private let networkScheduler: NetworkScheduler
  
  private var stations: [Station]?
  private var cancellable: AnyCancellable?

  private weak var view: FavoriteView?
  
  init(
    mapService service: MapService,
    favoriteRepository: FavoriteRepository,
    networkScheduler: NetworkScheduler
  ) {
    self.service = service
    self.favoriteRepository = favoriteRepository
    self.networkScheduler = networkScheduler
  }
  
  func attach(_ view: FavoriteView) {
    self.view = view
  }
  
  func fetchFavoriteStations() {
    self.view?.onShowLoading()

    let favoriteStationsIds = self.favoriteRepository.getFavoriteStationsIds()

    guard !favoriteStationsIds.isEmpty else {
      self.stations = nil
      self.view?.onDismissLoading()
      self.view?.onFetchStationsEmptyError()
      return
    }

    self.cancellable = self.service.fetchAllStations(from: favoriteStationsIds)
      .subscribe(on: networkScheduler.concurent)
      .receive(on: networkScheduler.main)
      .sink(receiveCompletion: { completion in
        switch completion {
          case .finished: break
          case .failure:
            self.view?.onDismissLoading()
            self.view?.onFetchStationsError()
        }
      }, receiveValue: { stations in
        self.stations = stations.sorted { return $0.code > $1.code }
        self.view?.onFetchStationsSuccess()
        self.view?.onDismissLoading()
      })
  }
  
  func getStation(at index: Int) -> Station? {
    self.stations?[index]
  }
  
  func getStationsCount() -> Int {
    self.stations?.count ?? 0
  }
  
}
