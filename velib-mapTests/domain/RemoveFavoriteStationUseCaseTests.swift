//
//  RemoveFavoriteStationUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class RemoveFavoriteStationUseCaseTests: XCTestCase {
    private let mockRepository = MockStationRepository()
    private var useCase: RemoveFavoriteStationUseCase!
    
    override func setUp() {
        useCase = RemoveFavoriteStationUseCase(stationRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedCode = "123"
        
        stub(mockRepository) { stub in
            when(stub).removeFavoriteStations(for: any()).thenDoNothing()
        }
        
        useCase.invoke(code: expectedCode)
        
        verify(mockRepository).removeFavoriteStations(for: expectedCode)
    }
}
