//
//  TestNetworkScheduler.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CombineSchedulers

@testable import velib_map

class TestNetworkScheduler: NetworkScheduler {
  let main: AnySchedulerOf<DispatchQueue> = DispatchQueue.immediate.eraseToAnyScheduler()
  let concurent: AnySchedulerOf<DispatchQueue> = DispatchQueue.immediate.eraseToAnyScheduler()
}
