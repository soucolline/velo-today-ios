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
  public let stationCode: String
  public let freeBikes: Int
  public let bikesAvailableType: [[String: Int]]

  enum CodingKeys: String, CodingKey {
    case freeDocks = "numDocksAvailable"
    case stationCode
    case freeBikes = "numBikesAvailable"
    case bikesAvailableType = "num_bikes_available_types"
  }
}

extension StationResponse {
  public var freeMechanicalBikes: Int? {
    for dict in bikesAvailableType {
      if let mechanical = dict["mechanical"] {
        return mechanical
      }
    }
    
    return nil
  }
  
  public var freeElectricBikes: Int? {
    for dict in bikesAvailableType {
      if let mechanical = dict["ebike"] {
        return mechanical
      }
    }
    
    return nil
  }
}
