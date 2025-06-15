//
//  StationResponse.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

public nonisolated struct StationResponse: Codable, Equatable {
  public nonisolated let freeDocks: Int
  public nonisolated let stationCode: String
  public nonisolated let freeBikes: Int
  public nonisolated let bikesAvailableType: [[String: Int]]

  nonisolated enum CodingKeys: String, CodingKey {
    case freeDocks = "numDocksAvailable"
    case stationCode
    case freeBikes = "numBikesAvailable"
    case bikesAvailableType = "num_bikes_available_types"
  }
}

extension StationResponse {
  public nonisolated var freeMechanicalBikes: Int? {
    for dict in bikesAvailableType {
      if let mechanical = dict["mechanical"] {
        return mechanical
      }
    }
    
    return nil
  }
  
  public nonisolated var freeElectricBikes: Int? {
    for dict in bikesAvailableType {
      if let mechanical = dict["ebike"] {
        return mechanical
      }
    }
    
    return nil
  }
}
