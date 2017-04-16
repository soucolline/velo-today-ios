//
//  Station.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreLocation

class Station {
  
  var number: Int?
  var name: String?
  var address: String?
  var lat: Double?
  var lng: Double?
  var banking: Bool?
  var bonus: Bool?
  var status: String?
  var contractName: String?
  var availableBikeStands: Int?
  var availableBikes: Int?
  var lastUpdate: Int?
  
  lazy var lastUpdateDate: Date? = {
    if let lastUpdate = self.lastUpdate {
      let timeInterval = TimeInterval(exactly: lastUpdate / 1000)
      let date = Date(timeIntervalSince1970: timeInterval!)
      return date
    }
    return nil
  }()
  
  lazy var location: CLLocationCoordinate2D? = {
    guard let latitude = self.lat, let longitude = self.lng else {
      return nil
    }
    
    let loc = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: latitude)!, longitude: CLLocationDegrees(exactly: longitude)!)
    return loc
  }()
  
}
