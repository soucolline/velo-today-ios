//
//  StationRepositoryTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class StationRepositoryTests: XCTestCase {
    private let mockStationRemoteDataSource = MockStationRemoteDataSource()
    private let mockFavoriteLocalDataSource = MockFavoriteLocalDataSource()
    private var repository: StationRepository!
    
    override func setUp() {
        repository = StationRepositoryImpl(
            stationRemoteDataSource: mockStationRemoteDataSource,
            favoriteLocalDataSource: mockFavoriteLocalDataSource
        )
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockStationRemoteDataSource)
        verifyNoMoreInteractions(mockFavoriteLocalDataSource)
    }
    
    func testFetchPins() async throws {
        let expectedStationResponse = [
            StationResponse(
                freeDocks: 1,
                code: "123",
                name: "Test station",
                totalDocks: 3,
                freeBikes: 4,
                freeMechanicalBikes: 5,
                freeElectricBikes: 6,
                geo: [12.23, 45.56]
            )
        ]

        let expectedDomainStation = [
            Station(
                freeDocks: 1,
                code: "123",
                name: "Test station",
                totalDocks: 3,
                freeBikes: 4,
                freeMechanicalBikes: 5,
                freeElectricBikes: 6,
                geolocation: [12.23, 45.56]
            )
        ]
        
        stub(mockStationRemoteDataSource) { stub in
            when(stub).fetchPins().thenReturn(expectedStationResponse)
        }
        
        let result = try await repository.fetchPins()
        
        XCTAssertEqual(result, expectedDomainStation)
        verify(mockStationRemoteDataSource).fetchPins()
    }
    
    func testFetchAllStations() async throws {
        let expectedStationResponse = [
            StationResponse(
                freeDocks: 1,
                code: "123",
                name: "Test station",
                totalDocks: 3,
                freeBikes: 4,
                freeMechanicalBikes: 5,
                freeElectricBikes: 6,
                geo: [12.23, 45.56]
            )
        ]

        let expectedDomainStation = [
            Station(
                freeDocks: 1,
                code: "123",
                name: "Test station",
                totalDocks: 3,
                freeBikes: 4,
                freeMechanicalBikes: 5,
                freeElectricBikes: 6,
                geolocation: [12.23, 45.56]
            )
        ]
        
        let expectedIds = ["1", "2", "3"]
        
        stub(mockStationRemoteDataSource) { stub in
            when(stub).fetchAllStations(from: any()).thenReturn(expectedStationResponse)
        }
        
        let result = try await repository.fetchAllStations(from: expectedIds)
        
        XCTAssertEqual(result, expectedDomainStation)
        verify(mockStationRemoteDataSource).fetchAllStations(from: expectedIds)
    }
    
    func testGetFavoriteStationsIds() {
        let expectedIds = ["1", "2", "3"]
        
        stub(mockFavoriteLocalDataSource) { stub in
            when(stub).getFavoriteStationsIds().thenReturn(expectedIds)
        }
        
        let result = repository.getFavoriteStationsIds()
        
        XCTAssertEqual(result, expectedIds)
        verify(mockFavoriteLocalDataSource).getFavoriteStationsIds()
    }
    
    func testAddFavoriteStation () {
        let expectedCode = "123"
        
        stub(mockFavoriteLocalDataSource) { stub in
            when(stub).addFavoriteStation(for: any()).thenDoNothing()
        }
        
        repository.addFavoriteStation(for: expectedCode)
        
        verify(mockFavoriteLocalDataSource).addFavoriteStation(for: expectedCode)
    }
    
    func testRemoveFavoriteStation () {
        let expectedCode = "123"
        
        stub(mockFavoriteLocalDataSource) { stub in
            when(stub).removeFavoriteStations(for: any()).thenDoNothing()
        }
        
        repository.removeFavoriteStations(for: expectedCode)
        
        verify(mockFavoriteLocalDataSource).removeFavoriteStations(for: expectedCode)
    }
    
    func testIsFavoriteStation() {
        let expectedResult = true
        let expectedCode = "123"
        
        stub(mockFavoriteLocalDataSource) { stub in
            when(stub).isFavoriteStation(from: any()).thenReturn(expectedResult)
        }
        
        let result = repository.isFavoriteStation(from: expectedCode)
        
        XCTAssertTrue(result)
        verify(mockFavoriteLocalDataSource).isFavoriteStation(from: expectedCode)
    }
    
    func testGetNumberOfFavoriteStations() {
        let expectedNumberOfFavoriteStations = 12
        
        stub(mockFavoriteLocalDataSource) { stub in
            when(stub).getNumberOfFavoriteStations().thenReturn(expectedNumberOfFavoriteStations)
        }
        
        let result = repository.getNumberOfFavoriteStations()
        
        XCTAssertEqual(result, expectedNumberOfFavoriteStations)
        verify(mockFavoriteLocalDataSource).getNumberOfFavoriteStations()
    }
}
