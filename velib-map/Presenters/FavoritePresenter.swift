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
  private let getSpecificStations: GetSpecificStationsUseCase
  private let getFavoriteStationsIds: GetFavoriteStationsIds
  private let networkScheduler: NetworkScheduler
  
  private var stations: [Station]?
  private var cancellable: AnyCancellable?

  private weak var view: FavoriteView?
  
  init(
    getSpecificStations: GetSpecificStationsUseCase,
    getFavoriteStationsIds: GetFavoriteStationsIds,
    networkScheduler: NetworkScheduler
  ) {
    self.getSpecificStations = getSpecificStations
    self.getFavoriteStationsIds = getFavoriteStationsIds
    self.networkScheduler = networkScheduler
  }
  
  func attach(_ view: FavoriteView) {
    self.view = view
  }
  
  func fetchFavoriteStations() {
    self.view?.onShowLoading()

    let favoriteStationsIds = self.getFavoriteStationsIds.invoke()

    guard !favoriteStationsIds.isEmpty else {
      self.stations = nil
      self.view?.onDismissLoading()
      self.view?.onFetchStationsEmptyError()
      return
    }

    self.cancellable = self.getSpecificStations.invoke(ids: favoriteStationsIds)
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
        self.stations = stations.sorted { $0.code > $1.code }
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
