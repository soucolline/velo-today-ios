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

final class Station: NSObject, MKAnnotation, Codable {
  
  let capacity: Int
  let name: String
  let numbikesavailable: Int
  let lastReported: Int
  let lon: Double?
  let stationId: Int
  let lat: Double?
  let xy: [Double]?
  let isInstalled: Int
  let isRenting: Int
  let numdocksavailable: Int
  let isReturning: Int
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  lazy var location: CLLocation? = {
    if let lat = self.lat, let lon = self.lon {
      return CLLocation(latitude: lat, longitude: lon)
    } else {
      return nil
    }
  }()
  
  lazy var lastUpdateDate: Date? = {
    let timeInterval = TimeInterval(exactly: self.lastReported) ?? 0.0
    let date = Date(timeIntervalSince1970: timeInterval)
    return date
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
  
  enum CodingKeys: String, CodingKey {
    case capacity
    case name
    case numbikesavailable
    case lastReported = "last_reported"
    case lon
    case stationId = "station_id"
    case lat
    case xy
    case isInstalled = "is_installed"
    case isRenting = "is_renting"
    case numdocksavailable
    case isReturning = "is_returning"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    self.capacity = try values.decodeIfPresent(Int.self, forKey: .capacity) ?? 0
    self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? "Station inconnue"
    self.numbikesavailable = try values.decode(Int.self, forKey: .numbikesavailable)
    self.lastReported = try values.decode(Int.self, forKey: .lastReported)
    self.lon  = try values.decodeIfPresent(Double.self, forKey: .lon) ?? nil
    self.stationId = try values.decodeIfPresent(Int.self, forKey: .stationId) ?? 0
    self.lat = try values.decodeIfPresent(Double.self, forKey: .lat) ?? nil
    self.xy = try values.decodeIfPresent(Array<Double>.self, forKey: .xy) ?? nil
    self.isInstalled = try values.decode(Int.self, forKey: .isInstalled)
    self.isRenting = try values.decode(Int.self, forKey: .isRenting)
    self.numdocksavailable = try values.decode(Int.self, forKey: .numdocksavailable)
    self.isReturning = try values.decode(Int.self, forKey: .isReturning)
    
    self.title = self.name
    self.subtitle = "\(self.numbikesavailable) vélos - \(self.numdocksavailable) places"
    super.init()
    if let coordinates = self.location?.coordinate {
      self.coordinate = coordinates
    }
  }
  
}
