//
//  Mapper.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class Mapper {
  
  static func mapStations(newsJSON: JSON) -> Station {
    let station = Station()
    
    station.number = newsJSON["number"].intValue
    station.name = newsJSON["name"].stringValue
    station.address = newsJSON["address"].stringValue
    station.lat = newsJSON["position"]["lat"].doubleValue
    station.lng = newsJSON["position"]["lng"].doubleValue
    station.banking = newsJSON["banking"].boolValue
    station.bonus = newsJSON["bonus"].boolValue
    station.status = newsJSON["status"].stringValue
    station.contractName = newsJSON["contract_name"].stringValue
    station.availableBikeStands = newsJSON["available_bike_stands"].intValue
    station.availableBikes = newsJSON["available_bikes"].intValue
    station.lastUpdate = newsJSON["last_update"].intValue
    station.coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng)
    station.title = station.name?.components(separatedBy: " - ").last
    
    if let bikes = station.availableBikes, let stands = station.availableBikeStands {
      station.subtitle = "\(bikes) vélos - \(stands) places"
    }
    
    return station
  }
  
}
