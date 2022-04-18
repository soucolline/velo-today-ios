//
//  StationRouterTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 10/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest

@testable import velib_map

class StationRouterTests: XCTestCase {
    func testGetAllStations() {
        let router = StationRouter.getAllStations
        
        XCTAssertEqual(router.baseURL, URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000")!)
        XCTAssertEqual(router.path, "")
        XCTAssertEqual(router.method, .get)
        XCTAssertEqual(router.sampleData, Data())
        XCTAssertNil(router.headers)
    }
    
    func testGetSpecificStation() {
        let expectedId = "123"
        let router = StationRouter.getSpecificStation(id: expectedId)
        
        XCTAssertEqual(router.baseURL, URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=\(expectedId)")!)
        XCTAssertEqual(router.path, "")
        XCTAssertEqual(router.method, .get)
        XCTAssertEqual(router.sampleData, Data())
        XCTAssertNil(router.headers)
    }
}
