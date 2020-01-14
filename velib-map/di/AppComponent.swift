//
//  AppComponent.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping
extension Assembler {
  // MARK: Shared instance

  static let shared: Assembler = {
    let container = Container()
    let assembler = Assembler([
      AppAssembly(),
      PresenterAssembly(),
      RepositoryAssembly(),
      NetworkAssembly()
    ], container: container)
    return assembler
  }()

  // MARK: Utils
  
  static func inject<Service>(_ serviceType: Service.Type) -> Service {
    Assembler.shared.resolver.resolve(serviceType)!
  }

  static func inject<Service>(_ serviceType: Service.Type, name: String?) -> Service {
    Assembler.shared.resolver.resolve(serviceType, name: name)!
  }
}
