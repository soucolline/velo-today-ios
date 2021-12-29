//
//  RepositoryAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping
class RepositoryAssembly: Assembly {
  func assemble(container: Container) {
    container.register(StationRepository.self) { resolver in
      StationRepositoryImpl(
        stationRemoteDataSource: resolver.resolve(StationRemoteDataSource.self)!,
        favoriteLocalDataSource: resolver.resolve(FavoriteLocalDataSource.self)!
      )
    }

    container.register(MapRepository.self) { resolver in
      MapRepositoryImpl(
        userDefaults: resolver.resolve(UserDefaults.self)!
      )
    }
  }
}
