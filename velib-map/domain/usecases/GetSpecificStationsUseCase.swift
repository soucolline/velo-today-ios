//
//  GetSpecificStationsUseCase.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine

class GetSpecificStationsUseCase {
  private let stationRepository: StationRepository

  init(stationRepository: StationRepository) {
    self.stationRepository = stationRepository
  }

  func invoke(ids: [String]) -> AnyPublisher<[UIStation], APIError> {
    stationRepository.fetchAllStations(from: ids)
      .map { $0.map { $0.toUIITem() } }
      .eraseToAnyPublisher()
  }
}