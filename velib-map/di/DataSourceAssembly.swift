//
//  DataSourceAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject
import Moya

// swiftlint:disable force_unwrapping
class DataSourceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(FavoriteLocalDataSource.self) { resolver in
      FavoriteLocalDataSourceImpl(
        with: resolver.resolve(UserDefaults.self)!
      )
    }

    container.register(StationRemoteDataSource.self) { resolver in
      StationRemoteDataSourceImpl(
        apiWorker: resolver.resolve(APIWorker.self)!,
        urlFactory: resolver.resolve(URLFactory.self)!,
        provider: resolver.resolve(MoyaProvider<StationRouter>.self)!
      )
    }
  }
}
