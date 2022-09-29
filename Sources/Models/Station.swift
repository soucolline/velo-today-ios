//
//  DomainStation.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

public struct Station: Equatable, Identifiable {
  public let id = UUID()
  public let freeDocks: Int
  public let code: String
  public let name: String
  public let totalDocks: Int
  public let freeBikes: Int
  public let freeMechanicalBikes: Int
  public let freeElectricBikes: Int
  public let geolocation: [Double]
  
  public init(
    freeDocks: Int,
    code: String,
    name: String,
    totalDocks: Int,
    freeBikes: Int,
    freeMechanicalBikes: Int,
    freeElectricBikes: Int,
    geolocation: [Double]
  ) {
    self.freeDocks = freeDocks
    self.code = code
    self.name = name
    self.totalDocks = totalDocks
    self.freeBikes = freeBikes
    self.freeMechanicalBikes = freeMechanicalBikes
    self.freeElectricBikes = freeElectricBikes
    self.geolocation = geolocation
  }

}

extension Station {
  public func toStationPin() -> StationMarker {
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
