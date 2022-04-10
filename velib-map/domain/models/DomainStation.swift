//
//  DomainStation.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct DomainStation: Equatable {
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geolocation: [Double]
}

extension DomainStation {
  func toUIITem() -> UIStation {
    UIStation(
      freeDocks: freeDocks,
      code: code,
      name: name,
      totalDocks: totalDocks,
      freeBikes: freeBikes,
      freeMechanicalBikes: freeMechanicalBikes,
      freeElectricBikes: freeElectricBikes,
      geolocation: geolocation
    )
  }
}
