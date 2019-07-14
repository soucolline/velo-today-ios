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
  private let service: CoreDataService
  private var currentStation: Station?
  private var isFavStation: FavoriteStation?
  
  init(service: CoreDataService) {
    self.service = service
  }
  
  func setView(view: DetailsViewDelegate) {
    self.delegate = view
  }
  
  func setData(currentStation: Station?) {
    self.currentStation = currentStation
    do {
      self.isFavStation = try CoreStore.fetchOne(From<FavoriteStation>(), Where<FavoriteStation>("number", isEqualTo: self.currentStation?.code))
    } catch {
      self.isFavStation = nil
    }
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
    do {
      return try CoreStore.fetchCount(From<FavoriteStation>())
    } catch {
      return 0
    }
  }
  
}
