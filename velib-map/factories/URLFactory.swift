//
//  URLFactory.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

// swiftlint:disable force_unwrapping
class URLFactory {
  func createFetchPinsUrl() -> URL {
    URL(string: K.Api.baseUrl)!
  }

  func createFetchStation(from id: String) -> URL {
    URL(string: K.Api.baseUrl + K.Api.stationQuery + "\(id)")!
  }
}
