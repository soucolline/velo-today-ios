//
//  NetworkSchedulers.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CombineSchedulers

protocol MainSchedulerProvider {
  var main: AnySchedulerOf<DispatchQueue> { get }
}

protocol IOSchedulerProvider {
  var concurent: AnySchedulerOf<DispatchQueue> { get }
}

protocol NetworkScheduler: MainSchedulerProvider, IOSchedulerProvider {}

class NetworkSchedulerImpl: NetworkScheduler {
  let main: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
  let concurent: AnySchedulerOf<DispatchQueue> = DispatchQueue.global(qos: .background).eraseToAnyScheduler()
}
