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

public final class StationMarker: NSObject, MKAnnotation, Identifiable {
  
  public let freeDocks: Int
  public let code: String
  public let name: String
  public let totalDocks: Int
  public let freeBikes: Int
  public let freeMechanicalBikes: Int
  public let freeElectricBikes: Int
  public let geolocation: [Double]
  
  public var title: String?
  
  public lazy var coordinate: CLLocationCoordinate2D = {
    CLLocationCoordinate2D(latitude: geolocation.first!, longitude: geolocation.last!)
  }()
  
  public init(
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
    
    self.title = name
    super.init()
  }
  
}
