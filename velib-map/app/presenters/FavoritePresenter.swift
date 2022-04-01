//
//  FavoritePresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 13/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol FavoriteView: AnyObject, Loadable {
  func onFetchStationsSuccess()
  func onFetchStationsEmptyError()
  func onFetchStationsError()
}

protocol FavoritePresenter {
  func attach(_ view: FavoriteView)
  
  func fetchFavoriteStations()
  func getStation(at index: Int) -> UIStation?
  func getStationsCount() -> Int
}

class FavoritePresenterImpl: FavoritePresenter {
  private let getSpecificStations: GetSpecificStationsUseCase
  private let getFavoriteStationsIds: GetFavoriteStationsIds
  
  private var stations: [UIStation]?

  private weak var view: FavoriteView?
  
  init(
    getSpecificStations: GetSpecificStationsUseCase,
    getFavoriteStationsIds: GetFavoriteStationsIds
  ) {
    self.getSpecificStations = getSpecificStations
    self.getFavoriteStationsIds = getFavoriteStationsIds
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

    Task {
      do {
        self.stations = try await getSpecificStations.invoke(ids: favoriteStationsIds).sorted { $0.code > $1.code }
        self.view?.onFetchStationsSuccess()
        self.view?.onDismissLoading()
      } catch {
        self.view?.onDismissLoading()
        self.view?.onFetchStationsError()
      }
    }
  }
  
  func getStation(at index: Int) -> UIStation? {
    self.stations?[index]
  }
  
  func getStationsCount() -> Int {
    self.stations?.count ?? 0
  }
  
}
