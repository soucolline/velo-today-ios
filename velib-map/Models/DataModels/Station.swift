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
  
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geo: [Double]
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  lazy var location: CLLocation? = {
    if let lat = self.geo.first, let lon = self.geo.last {
      return CLLocation(latitude: lat, longitude: lon)
    } else {
      return nil
    }
  }()
  
  enum CodingKeys: String, CodingKey {
    case freeDocks = "numdocksavailable"
    case code = "stationcode"
    case name
    case totalDocks = "capacity"
    case freeBikes = "numbikesavailable"
    case freeMechanicalBikes = "mechanical"
    case freeElectricBikes = "ebike"
    case geo = "coordonnees_geo"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.freeDocks = try values.decode(Int.self, forKey: .freeDocks)
    self.code = try values.decode(String.self, forKey: .code)
    self.name = try values.decode(String.self, forKey: .name)
    self.totalDocks = try values.decode(Int.self, forKey: .totalDocks)
    self.freeBikes = try values.decode(Int.self, forKey: .freeBikes)
    self.freeMechanicalBikes = try values.decode(Int.self, forKey: .freeMechanicalBikes)
    self.freeElectricBikes = try values.decode(Int.self, forKey: .freeElectricBikes)
    self.geo = try values.decode(Array<Double>.self, forKey: .geo)
    
    self.title = self.name
    self.subtitle = "\(self.freeBikes) vélos - \(self.freeDocks) places"
    super.init()
    if let coordinates = self.location?.coordinate {
      self.coordinate = coordinates
    }
  }

  init(
    freeDocks: Int,
    code: String,
    name: String,
    totalDocks: Int,
    freeBikes: Int,
    freeMechanicalBikes: Int,
    freeElectricBikes: Int,
    geo: [Double]
  ) {
    self.freeDocks = freeDocks
    self.code = code
    self.name = name
    self.totalDocks = totalDocks
    self.freeBikes = freeBikes
    self.freeMechanicalBikes = freeMechanicalBikes
    self.freeElectricBikes = freeElectricBikes
    self.geo = geo
  }
  
}
