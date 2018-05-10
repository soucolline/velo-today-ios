//
//  Station.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Station: NSObject, MKAnnotation {
  
  var stationId: Int?
  var name: String?
  var address: String?
  var lat: Double = 0.0
  var lon: Double = 0.0
  var banking: Bool?
  var bonus: Bool?
  var status: String?
  var contractName: String?
  var numdocksavailable: Int?
  var numbikesavailable: Int?
  var lastReported: Int?
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  lazy var location: CLLocation = {
    let lat = self.lat
    let lng = self.lon
    return CLLocation(latitude: lat, longitude: lng)
  }()
  
  lazy var lastUpdateDate: Date? = {
    if let lastUpdate = self.lastReported {
      let timeInterval = TimeInterval(exactly: lastUpdate)
      let date = Date(timeIntervalSince1970: timeInterval!)
      return date
    }
    return nil
  }()
  
  lazy var lastUpdateDateString: String? = {
    if let lastUpdate = self.lastUpdateDate {
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone.current
      formatter.locale = Locale.current
      formatter.dateFormat =  "yyyy-MM-dd' à 'HH:mm"
      return "Mis à jour le \(formatter.string(from: lastUpdate))"
    }
    return ""
  }()
  
}
