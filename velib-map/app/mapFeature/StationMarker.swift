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

final class StationMarker: NSObject, MKAnnotation, Identifiable {
  
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geolocation: [Double]
  
  lazy var coordinate: CLLocationCoordinate2D = {
    CLLocationCoordinate2D(latitude: geolocation.first!, longitude: geolocation.last!)
  }()
  
  init(
    freeDocks: Int,
    code: String,
    name: String,
    totalDocks: Int,
    freeBikes: Int,
    freeMechanicalBikes: Int,
    freeElectricBikes: Int,
    geolocation: [Double]
  ) {
    self.freeDocks = freeDocks
    self.code = code
    self.name = name
    self.totalDocks = totalDocks
    self.freeBikes = freeBikes
    self.freeMechanicalBikes = freeMechanicalBikes
    self.freeElectricBikes = freeElectricBikes
    self.geolocation = geolocation
    
    super.init()
  }
  
}
