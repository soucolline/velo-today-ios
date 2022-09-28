//
//  StationResponse.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

public struct StationResponse: Codable, Equatable {
  public let freeDocks: Int
  public let code: String
  public let name: String
  public let totalDocks: Int
  public let freeBikes: Int
  public let freeMechanicalBikes: Int
  public let freeElectricBikes: Int
  public let geo: [Double]

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
  public func toStation() -> Station {
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
