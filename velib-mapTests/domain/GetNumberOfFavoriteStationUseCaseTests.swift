//
//  GetNumberOfFavoriteStationUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class GetNumberOfFavoriteStationUseCaseTests: XCTestCase {
    private let mockRepository = MockStationRepository()
    private var useCase: GetNumberOfFavoriteStationUseCase!
    
    override func setUp() {
        useCase = GetNumberOfFavoriteStationUseCase(stationRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedNumber = 3
        
        stub(mockRepository) { stub in
            when(stub).getNumberOfFavoriteStations().thenReturn(expectedNumber)
        }
        
        let result = useCase.invoke()
        
        XCTAssertEqual(result, expectedNumber)
        verify(mockRepository).getNumberOfFavoriteStations()
    }
}
