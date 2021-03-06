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
        service: resolver.resolve(MapService.self)!,
        repository: resolver.resolve(PreferencesRepository.self)!,
        networkScheduler: resolver.resolve(NetworkScheduler.self)!
      )
    }

    container.register(DetailsPresenter.self) { resolver in
      DetailsPresenterImpl(
        favoriteRepository: resolver.resolve(FavoriteRepository.self)!
      )
    }

    container.register(FavoritePresenter.self) { resolver in
      FavoritePresenterImpl(
        mapService: resolver.resolve(MapService.self)!,
        favoriteRepository: resolver.resolve(FavoriteRepository.self)!,
        networkScheduler: resolver.resolve(NetworkScheduler.self)!
      )
    }

    container.register(SettingsPresenter.self) { resolver in
      SettingsPresenterImpl(
        preferencesRepository: resolver.resolve(PreferencesRepository.self)!
      )
    }
  }
}
