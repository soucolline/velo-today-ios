//
//  FactoryAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

class FactoryAssembly: Assembly {
  func assemble(container: Container) {
    container.register(URLFactory.self) { _ in
      URLFactory()
    }
  }
}
