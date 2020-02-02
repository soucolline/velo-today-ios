//
//  DetailsPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreLocation

protocol DetailsViewDelegate: class {
  func onAddFavoriteSuccess(numberOfFavoriteStations: Int)
  func onRemoveFavoriteSuccess(numberOfFavoriteStations: Int)
  
  func onAddFavoriteError()
  func onRemoveFavoriteError()
}

protocol DetailsPresenter {
  func setView(view: DetailsViewDelegate)
  func setData(currentStation: Station?)
  
  func addFavorite()
  func removeFavorite()
  
  func getCurrentStation() -> Station?
  func getCurrentStationTitle() -> String
  func getCurrentStationLocation() -> CLLocation?
  
  func isFavoriteStation() -> Bool
}

class DetailsPresenterImpl: DetailsPresenter {
  
  private weak var delegate: DetailsViewDelegate?
  private let favoriteRepository: FavoriteRepository
  private var currentStation: Station?
  private var isFavStation = false
  
  init(with favoriteRepository: FavoriteRepository) {
    self.favoriteRepository = favoriteRepository
  }
  
  func setView(view: DetailsViewDelegate) {
    self.delegate = view
  }
  
  func setData(currentStation: Station?) {
    self.currentStation = currentStation

    if let code = self.currentStation?.code {
      self.isFavStation = self.favoriteRepository.isFavoriteStation(from: code)
    } else {
      self.isFavStation = false
    }
  }
  
  func addFavorite() {
    guard let station = self.currentStation else {
      self.delegate?.onAddFavoriteError()
      return
    }

    self.favoriteRepository.addFavoriteStation(for: station.code)
    self.isFavStation = true
    self.delegate?.onAddFavoriteSuccess(numberOfFavoriteStations: self.favoriteRepository.getNumberOfFavoriteStations())
  }
  
  func removeFavorite() {
    guard let station = self.currentStation else {
      self.delegate?.onRemoveFavoriteError()
      return
    }

    self.favoriteRepository.removeFavoriteStations(for: station.code)
    self.isFavStation = false
    self.delegate?.onRemoveFavoriteSuccess(numberOfFavoriteStations: self.favoriteRepository.getNumberOfFavoriteStations())
  }
  
  func getCurrentStation() -> Station? {
    self.currentStation
  }
  
  func getCurrentStationTitle() -> String {
    self.currentStation?.name ?? "N/A"
  }
  
  func getCurrentStationLocation() -> CLLocation? {
    self.currentStation?.location
  }
  
  func isFavoriteStation() -> Bool {
    self.isFavStation
  }
}
