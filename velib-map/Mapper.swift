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
    
    station.stationId = newsJSON["fields"]["station_id"].intValue
    station.name = newsJSON["fields"]["name"].stringValue
    station.address = newsJSON["address"].stringValue
    station.lat = newsJSON["fields"]["lat"].doubleValue
    station.lon = newsJSON["fields"]["lon"].doubleValue
    station.banking = newsJSON["banking"].boolValue
    station.bonus = newsJSON["bonus"].boolValue
    station.status = newsJSON["status"].stringValue
    station.contractName = newsJSON["contract_name"].stringValue
    station.numdocksavailable = newsJSON["fields"]["numdocksavailable"].intValue
    station.numbikesavailable = newsJSON["fields"]["numbikesavailable"].intValue
    station.coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.lon)
    station.title = station.name?.components(separatedBy: " - ").last
    station.lastReported = newsJSON["fields"]["last_reported"].intValue
    
    if let bikes = station.numbikesavailable, let stands = station.numdocksavailable {
      station.subtitle = "\(bikes) vélos - \(stands) places"
    }
    
    return station
  }
  
}
