//
//  Station.swift
//  TodayExtension
//
//  Created by Thomas Guilleminot on 25/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct FetchStationObjectResponseRoot: Decodable {
  let records: [FetchStationObjectResponse]
}

struct FetchStationObjectResponse: Codable {

  let station: Station

  enum CodingKeys: String, CodingKey {
    case station = "fields"
  }

}
struct Station: Codable {
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
