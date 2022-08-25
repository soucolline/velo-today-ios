//
//  StationResponse.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct StationResponse: Codable, Equatable {
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geo: [Double]

  enum CodingKeys: String, CodingKey {
    case freeDocks = "numdocksavailable"
    case code = "stationcode"
    case name
    case totalDocks = "capacity"
    case freeBikes = "numbikesavailable"
    case freeMechanicalBikes = "mechanical"
    case freeElectricBikes = "ebike"
    case geo = "coordonnees_geo"
  }
}

extension StationResponse {
  func toStation() throws -> Station {
    Station(
      freeDocks: freeDocks,
      code: code,
      name: name,
      totalDocks: totalDocks,
      freeBikes: freeBikes,
      freeMechanicalBikes: freeMechanicalBikes,
      freeElectricBikes: freeElectricBikes,
      geolocation: geo
    )
  }
}
