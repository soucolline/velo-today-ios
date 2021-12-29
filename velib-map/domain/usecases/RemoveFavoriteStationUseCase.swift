//
//  RemoveFavoriteStationUseCase.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

class RemoveFavoriteStationUseCase {
  private let stationRepository: StationRepository

  init(stationRepository: StationRepository) {
    self.stationRepository = stationRepository
  }

  func invoke(code: String) {
    stationRepository.removeFavoriteStations(for: code)
  }
}
