//
//  GetAllStationsUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import XCTest

@testable import velib_map

class GetAllStationsUseCaseTests: XCTestCase {
    private let mockRepository = MockStationRepository()
    private var useCase: GetAllStationsUseCase!
    
    override func setUp() {
        useCase = GetAllStationsUseCase(stationRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() async throws {
        let expectedDomainStation = [Station(
            freeDocks: 1,
            code: "123",
            name: "Test name",
            totalDocks: 3,
            freeBikes: 4,
            freeMechanicalBikes: 5,
            freeElectricBikes: 6,
            geolocation: [12.23, 45.67]
        )]
        
        let expectedUIStation = expectedDomainStation.map { $0.toStationPin() }
        
        stub(mockRepository) { stub in
            when(stub).fetchPins().thenReturn(expectedDomainStation)
        }
        
        let result = try await useCase.invoke()
        
        XCTAssertEqual(result.first!.freeDocks, expectedUIStation.first!.freeDocks)
        verify(mockRepository).fetchPins()
    }
}
