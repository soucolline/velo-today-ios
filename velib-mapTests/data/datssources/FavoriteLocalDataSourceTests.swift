//
//  FavoriteLocalDataSourceTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class FavoriteLocalDataSourceTest: XCTestCase {
    private let mockUserDefaults = UserDefaults(suiteName: #file)!
    private var dataSource: FavoriteLocalDataSource!
    
    private let stationsIdKey = "favoriteStationsCode"
    
    override func setUp() {
        dataSource = FavoriteLocalDataSourceImpl(with: mockUserDefaults)
        
        mockUserDefaults.dictionaryRepresentation().keys.forEach { key in
            mockUserDefaults.removeObject(forKey: key)
        }
    }
    
    func testGetFavoriteStationsIds() {
        let expectedStationIds = ["1", "2", "3"]
        mockUserDefaults.set(expectedStationIds, forKey: stationsIdKey)
        
        let result = dataSource.getFavoriteStationsIds()
        
        XCTAssertEqual(result, expectedStationIds)
    }
    
    func testGetFavoriteStationsIdsWhenEmpty() {
        let expectedStationIds: [String] = []

        let result = dataSource.getFavoriteStationsIds()
        
        XCTAssertEqual(result, expectedStationIds)
    }
    
    func testAddFavoriteStation() {
        let expectedCode = "123"
        
        dataSource.addFavoriteStation(for: expectedCode)
        
        XCTAssertEqual(mockUserDefaults.value(forKey: stationsIdKey) as! [String], [expectedCode])
    }
    
    func testAddFavoriteStationWhenAlreadyExisting() {
        let expectedCode = "123"
        mockUserDefaults.set(expectedCode, forKey: stationsIdKey)
        
        dataSource.addFavoriteStation(for: expectedCode)
        
        XCTAssertEqual(mockUserDefaults.value(forKey: stationsIdKey) as! [String], [expectedCode])
    }
    
    func testRemoveFavoriteStation() {
        let expectedCode = "123"
        mockUserDefaults.set([expectedCode], forKey: stationsIdKey)
        
        dataSource.removeFavoriteStations(for: expectedCode)
        
        XCTAssertEqual(mockUserDefaults.value(forKey: stationsIdKey) as! [String], [])
    }
    
    func testRemoveFavoriteStationWhenNotExisting() {
        let expectedCode = "123"
        mockUserDefaults.set(["456"], forKey: stationsIdKey)
        
        dataSource.removeFavoriteStations(for: expectedCode)
        
        XCTAssertEqual(mockUserDefaults.value(forKey: stationsIdKey) as! [String], ["456"])
    }
    
    func testIsFavoriteStation() {
        let expectedCode = "123"
        mockUserDefaults.set([expectedCode], forKey: stationsIdKey)
        
        XCTAssertTrue(dataSource.isFavoriteStation(from: expectedCode))
    }
    
    func testGetNumberOfFavoriteStations() {
        let expectedStationsIds = ["1", "2", "3"]
        let expectedCount = expectedStationsIds.count
        
        mockUserDefaults.set(expectedStationsIds, forKey: stationsIdKey)
        
        XCTAssertEqual(dataSource.getNumberOfFavoriteStations(), expectedCount)
    }
}
