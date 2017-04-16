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
  case stationFrom(City)
  
  var url: String {
    switch(self) {
    case .stationFrom(let city):
      return "https://api.jcdecaux.com/vls/v1/stations?contract=\(city.rawValue)&apiKey=\(API_CLIENT_ID)"
    }
  }
}
