//
//  GetFavoriteStationsIdsTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class GetFavoriteStationsIdsTests: XCTestCase {
    private let mockRepository = MockStationRepository()
    private var useCase: GetFavoriteStationsIds!
    
    override func setUp() {
        useCase = GetFavoriteStationsIds(stationRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedStationsIds = ["1", "2", "3"]
        
        stub(mockRepository) { stub in
            when(stub).getFavoriteStationsIds().thenReturn(expectedStationsIds)
        }
        
        let result = useCase.invoke()
        
        XCTAssertEqual(result, expectedStationsIds)
        verify(mockRepository).getFavoriteStationsIds()
    }
}
