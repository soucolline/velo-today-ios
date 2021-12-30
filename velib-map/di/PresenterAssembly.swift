//
//  PresenterAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping
class PresenterAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MapPresenter.self) { resolver in
      MapPresenterImpl(
        getAllStations: resolver.resolve(GetAllStationsUseCase.self)!,
        getMapStyle: resolver.resolve(GetMapStyleUseCase.self)!
      )
    }

    container.register(DetailsPresenter.self) { resolver in
      DetailsPresenterImpl(
        addFavoriteStation: resolver.resolve(AddFavoriteStationUseCase.self)!,
        removeFavoriteStation: resolver.resolve(RemoveFavoriteStationUseCase.self)!,
        getNumberOfFavoriteStation: resolver.resolve(GetNumberOfFavoriteStationUseCase.self)!,
        isFavoriteStation: resolver.resolve(IsFavoriteStationUseCase.self)!
      )
    }

    container.register(FavoritePresenter.self) { resolver in
      FavoritePresenterImpl(
        getSpecificStations: resolver.resolve(GetSpecificStationsUseCase.self)!,
        getFavoriteStationsIds: resolver.resolve(GetFavoriteStationsIds.self)!
      )
    }

    container.register(SettingsPresenter.self) { resolver in
      SettingsPresenterImpl(
        getMapStyle: resolver.resolve(GetMapStyleUseCase.self)!,
        setMapStyle: resolver.resolve(SetMapStyleUseCase.self)!
      )
    }
  }
}
