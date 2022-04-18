//
//  IsFavoriteStationUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import XCTest

@testable import velib_map

class IsFavoriteStationUseCaseTests: XCTestCase {
    private let mockRepository = MockStationRepository()
    private var useCase: IsFavoriteStationUseCase!
    
    override func setUp() {
        useCase = IsFavoriteStationUseCase(stationRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedCode = "123"
        let expectedResult = true
        
        stub(mockRepository) { stub in
            when(stub).isFavoriteStation(from: any()).thenReturn(expectedResult)
        }
        
        let result = useCase.invoke(code: expectedCode)
        
        XCTAssertTrue(result)
        verify(mockRepository).isFavoriteStation(from: expectedCode)
    }
}
