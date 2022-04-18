//
//  DetailsPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreLocation

protocol DetailsView: AnyObject {
  func onAddFavoriteSuccess(numberOfFavoriteStations: Int)
  func onRemoveFavoriteSuccess(numberOfFavoriteStations: Int)
  
  func onAddFavoriteError()
  func onRemoveFavoriteError()
}

protocol DetailsPresenter {
  func attach(_ view: DetailsView)
  func setData(currentStation: UIStation?)
  
  func addFavorite()
  func removeFavorite()
  
  func getCurrentStation() -> UIStation?
  func getCurrentStationTitle() -> String
  func getCurrentStationLocation() -> CLLocation?
  
  func getIsFavoriteStation() -> Bool
}

class DetailsPresenterImpl: DetailsPresenter {
  private let addFavoriteStation: AddFavoriteStationUseCase
  private let removeFavoriteStation: RemoveFavoriteStationUseCase
  private let getNumberOfFavoriteStation: GetNumberOfFavoriteStationUseCase
  private let isFavoriteStation: IsFavoriteStationUseCase

  private var currentStation: UIStation?
  private var isFavStation = false

  private weak var view: DetailsView?
  
  init(
    addFavoriteStation: AddFavoriteStationUseCase,
    removeFavoriteStation: RemoveFavoriteStationUseCase,
    getNumberOfFavoriteStation: GetNumberOfFavoriteStationUseCase,
    isFavoriteStation: IsFavoriteStationUseCase
  ) {
    self.addFavoriteStation = addFavoriteStation
    self.removeFavoriteStation = removeFavoriteStation
    self.getNumberOfFavoriteStation = getNumberOfFavoriteStation
    self.isFavoriteStation = isFavoriteStation
  }

  func attach(_ view: DetailsView) {
    self.view = view
  }
  
  func setData(currentStation: UIStation?) {
    self.currentStation = currentStation

    if let code = self.currentStation?.code {
      self.isFavStation = self.isFavoriteStation.invoke(code: code)
    } else {
      self.isFavStation = false
    }
  }
  
  func addFavorite() {
    guard let station = self.currentStation else {
      self.view?.onAddFavoriteError()
      return
    }

    self.addFavoriteStation.invoke(code: station.code)
    self.isFavStation = true
    self.view?.onAddFavoriteSuccess(numberOfFavoriteStations: self.getNumberOfFavoriteStation.invoke())
  }
  
  func removeFavorite() {
    guard let station = self.currentStation else {
      self.view?.onRemoveFavoriteError()
      return
    }

    self.removeFavoriteStation.invoke(code: station.code)
    self.isFavStation = false
    self.view?.onRemoveFavoriteSuccess(numberOfFavoriteStations: self.getNumberOfFavoriteStation.invoke())
  }
  
  func getCurrentStation() -> UIStation? {
    self.currentStation
  }
  
  func getCurrentStationTitle() -> String {
    self.currentStation?.name ?? "N/A"
  }
  
  func getCurrentStationLocation() -> CLLocation? {
    self.currentStation?.location
  }
  
  func getIsFavoriteStation() -> Bool {
    self.isFavStation
  }
}
