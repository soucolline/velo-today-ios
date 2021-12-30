//
//  RouterAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 30/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Moya
import Swinject

class RouterAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MoyaProvider<StationRouter>.self) { _ in
      MoyaProvider<StationRouter>()
    }
  }
}
