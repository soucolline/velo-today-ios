//
//  GetAllStationsUseCase.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

class GetAllStationsUseCase {
  private let stationRepository: StationRepository

  init(stationRepository: StationRepository) {
    self.stationRepository = stationRepository
  }

  func invoke() -> AnyPublisher<[Station], APIError> {
    stationRepository.fetchPins()
  }
}
