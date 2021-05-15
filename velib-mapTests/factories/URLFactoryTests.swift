//
//  URLFactoryTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest

@testable import velib_map

class URLFactoryTests: XCTestCase {
  private let factory = URLFactory()

  func testCreateFetchPinsUrl() {
    XCTAssertEqual(factory.createFetchPinsUrl(), URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000")!)
  }

  func testCreateFetchStation() {
    XCTAssertEqual(factory.createFetchStation(from: "123"), URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=123")!)
  }
}
