//
//  DetailsPresenterImpl.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreStore
import CoreLocation

protocol DetailsViewDelegate: class {
  func onAddFavoriteSuccess(numberOfFavoriteStations: Int)
  func onRemoveFavoriteSuccess(numberOfFavoriteStations: Int)
  
  func onAddFavoriteError()
  func onRemoveFavoriteError()
}

protocol DetailsPresenter {
  func addFavorite()
  func removeFavorite()
  
  func getCurrentStation() -> Station?
  func getCurrentStationTitle() -> String
  func getCurrentStationLocation() -> CLLocation?
  
  func isFavoriteStation() -> Bool
}

class DetailsPresenterImpl: DetailsPresenter {
  
  private weak var delegate: DetailsViewDelegate?
  private let service: CoreDataService
  private let currentStation: Station?
  private var isFavStation: FavoriteStation?
  
  init(delegate: DetailsViewDelegate, service: CoreDataService, currentStation: Station?) {
    self.delegate = delegate
    self.service = service
    self.currentStation = currentStation
    
    self.isFavStation = CoreStore.fetchOne(From<FavoriteStation>(), Where<FavoriteStation>("number", isEqualTo: self.currentStation?.stationId))
  }
  
  func addFavorite() {
    guard let station = self.currentStation else {
      self.delegate?.onAddFavoriteError()
      return
    }
    
    self.service.addFavorite(station: station).then { favoriteStation in
      self.isFavStation = favoriteStation
      self.delegate?.onAddFavoriteSuccess(numberOfFavoriteStations: self.getNumberOfFavoriteStations())
    }.catch { _ in
      self.delegate?.onAddFavoriteError()
    }
  }
  
  func removeFavorite() {
    guard let station = self.currentStation else {
      self.delegate?.onRemoveFavoriteError()
      return
    }
    
    self.service.removeFavorite(station: station).then { _ in
      self.isFavStation = nil
      self.delegate?.onRemoveFavoriteSuccess(numberOfFavoriteStations: self.getNumberOfFavoriteStations())
    }.catch { _ in
        self.delegate?.onRemoveFavoriteError()
    }
  }
  
  func getCurrentStation() -> Station? {
    return self.currentStation
  }
  
  func getCurrentStationTitle() -> String {
    return self.currentStation?.name ?? "N/A"
  }
  
  func getCurrentStationLocation() -> CLLocation? {
    return self.currentStation?.location
  }
  
  func isFavoriteStation() -> Bool {
    return self.isFavStation != nil ? true : false
  }
  
  private func getNumberOfFavoriteStations() -> Int {
    return CoreStore.fetchCount(From<FavoriteStation>()) ?? 0
  }
  
}
