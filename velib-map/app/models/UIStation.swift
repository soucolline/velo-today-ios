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

final class UIStation: NSObject, MKAnnotation {
  
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeMechanicalBikes: Int
  let freeElectricBikes: Int
  let geolocation: [Double]
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  lazy var location: CLLocation? = {
    if let lat = self.geolocation.first, let lon = self.geolocation.last {
      return CLLocation(latitude: lat, longitude: lon)
    } else {
      return nil
    }
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

    self.title = self.name
    self.subtitle = "\(self.freeBikes) vélos - \(self.freeDocks) places"
    super.init()
    if let coordinates = self.location?.coordinate {
      self.coordinate = coordinates
    }
  }
  
}
