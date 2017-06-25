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
  
  var number: Int?
  var name: String?
  var address: String?
  var lat: Double = 0.0
  var lng: Double = 0.0
  var banking: Bool?
  var bonus: Bool?
  var status: String?
  var contractName: String?
  var availableBikeStands: Int?
  var availableBikes: Int?
  var lastUpdate: Int?
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  lazy var location: CLLocation = {
    let lat = self.lat
    let lng = self.lng
    return CLLocation(latitude: lat, longitude: lng)
  }()
  
  lazy var lastUpdateDate: Date? = {
    if let lastUpdate = self.lastUpdate {
      let timeInterval = TimeInterval(exactly: lastUpdate / 1000)
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
