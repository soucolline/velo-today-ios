//
//  MapRepositoryTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class MapRepositoryTests: XCTestCase {
    private let mockUserDefaults = UserDefaults(suiteName: #file)!
    private var repository: MapRepository!
    
    private let mapStyleKey = "mapStyle"
    
    override func setUp() {
        repository = MapRepositoryImpl(userDefaults: mockUserDefaults)
        
        mockUserDefaults.dictionaryRepresentation().keys.forEach { key in
            mockUserDefaults.removeObject(forKey: key)
        }
    }
    
    func testGetMapStyleWithData() {
        mockUserDefaults.set("satelliteStyle", forKey: mapStyleKey)
        
        let result = repository.getMapStyle()
        
        XCTAssertEqual(result, .satellite)
    }
    
    func testGetMapStyleWithoutData() {
        let result = repository.getMapStyle()
        
        XCTAssertEqual(result, .normal)
    }
    
    func testSetMapStyle() {
        let expectedMapStyle = "hybridStyle"
        
        repository.setMapStyle(identifier: expectedMapStyle)
        
        XCTAssertEqual(mockUserDefaults.string(forKey: mapStyleKey), expectedMapStyle)
    }
}
