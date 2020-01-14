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
        repository: resolver.resolve(PreferencesRepository.self)!
      )
    }

    container.register(DetailsPresenter.self) { resolver in
      DetailsPresenterImpl(
        with: resolver.resolve(FavoriteRepository.self)!
      )
    }

    container.register(FavoritePresenter.self) { resolver in
      FavoritePresenterImpl(
        with: resolver.resolve(MapService.self)!,
        favoriteRepository: resolver.resolve(FavoriteRepository.self)!
      )
    }
  }
}
