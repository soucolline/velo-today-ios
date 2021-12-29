//
//  GetMapStyleUseCase.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

class GetMapStyleUseCase {
  private let mapRepository: MapRepository

  init(mapRepository: MapRepository) {
    self.mapRepository = mapRepository
  }

  func invoke() -> MapStyle {
    mapRepository.getMapStyle()
  }
}
