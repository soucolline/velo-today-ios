//
//  FetchStationObjectResponse.swift
//  velib-map
//
//  Created by Zlatan on 15/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

struct FetchStationObjectResponseRoot: Codable {
  
  let records: [FetchStationObjectResponse]
  
}

struct FetchStationObjectResponse: Codable {
  
  let station: Station
  
  enum CodingKeys: String, CodingKey {
    case station = "fields"
  }
  
}
