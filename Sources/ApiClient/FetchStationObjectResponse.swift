//
//  FetchStationObjectResponse.swift
//  velib-map
//
//  Created by Zlatan on 15/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Models

nonisolated struct FetchStationObjectResponseRoot: Decodable {
  
  let data: FetchStationObjectResponseData
  
}

nonisolated struct FetchStationObjectResponseData: Decodable {
  let stations: [StationResponse]
}
