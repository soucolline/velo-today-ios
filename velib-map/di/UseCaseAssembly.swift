//
//  UseCaseAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping
class UseCaseAssembly: Assembly {
  func assemble(container: Container) {
    container.register(GetAllStationsUseCase.self) { resolver in
      GetAllStationsUseCase(
        stationRepository: resolver.resolve(StationRepository.self)!
      )
    }

    container.register(GetMapStyleUseCase.self) { resolver in
      GetMapStyleUseCase(
        mapRepository: resolver.resolve(MapRepository.self)!
      )
    }

    container.register(IsFavoriteStationUseCase.self) { resolver in
      IsFavoriteStationUseCase(
        stationRepository: resolver.resolve(StationRepository.self)!
      )
    }

    container.register(AddFavoriteStationUseCase.self) { resolver in
      AddFavoriteStationUseCase(
        stationRepository: resolver.resolve(StationRepository.self)!
      )
    }

    container.register(RemoveFavoriteStationUseCase.self) { resolver in
      RemoveFavoriteStationUseCase(
        stationRepository: resolver.resolve(StationRepository.self)!
      )
    }

    container.register(GetNumberOfFavoriteStationUseCase.self) { resolver in
      GetNumberOfFavoriteStationUseCase(
        stationRepository: resolver.resolve(StationRepository.self)!
      )
    }
  }
}
