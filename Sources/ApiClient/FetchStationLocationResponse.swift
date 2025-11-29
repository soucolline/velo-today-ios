//
//  File.swift
//  
//
//  Created by Thomas Guilleminot on 03/12/2022.
//

import Foundation

struct FetchStationLocationResponseRoot: Decodable {
  let data: FetchStationLocationResponseData
}

struct FetchStationLocationResponseData: Decodable {
  let stations: [FetchStationLocationResponse]
}

struct FetchStationLocationResponse: Decodable {
  let lat: Double
  let lon: Double
  let stationCode: String
  let name: String
  let capacity: Int
}
