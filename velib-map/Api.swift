//
//  Api.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation

private let API_CLIENT_ID = "bd904005c3639b0ac73c745dcd246a5e21c1577f"

enum Api {
  case allStations
  case stationFrom(Int32)
  
  var url: String {
    switch self {
    case .allStations:
      return "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000"
    case .stationFrom(let number):
      return "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=station_id%3D+\(number)"
    }
  }
}
