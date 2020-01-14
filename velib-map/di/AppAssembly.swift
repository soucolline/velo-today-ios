//
//  AppAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
  func assemble(container: Container) {
    container.register(UserDefaults.self) { _ in
      UserDefaults.standard
    }.inObjectScope(.container)
  }
}
