//
//  NetworkAssembly.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping
class NetworkAssembly: Assembly {
  func assemble(container: Container) {
    container.register(NetworkSession.self) { _ in
      let session = URLSessionConfiguration.default
      session.timeoutIntervalForRequest = 10.0
      return URLSession(configuration: session)
    }

    container.register(APIWorker.self) { resolver in
      APIWorkerImpl(
        with: resolver.resolve(NetworkSession.self)!
      )
    }

    container.register(NetworkScheduler.self) { _ in
      NetworkSchedulerImpl()
    }
  }
}
