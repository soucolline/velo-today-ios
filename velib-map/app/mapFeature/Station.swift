//
//  DomainStation.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct Station: Equatable, Identifiable {
  let id = UUID()
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geolocation: [Double]
}

extension Station {
  func toStationPin() -> StationMarker {
    StationMarker(
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
