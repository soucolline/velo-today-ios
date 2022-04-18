//
//  GetMapStyleUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class GetMapStyleUseCaseTests: XCTestCase {
    private let mockRepository = MockMapRepository()
    private var useCase: GetMapStyleUseCase!
    
    override func setUp() {
        useCase = GetMapStyleUseCase(mapRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedMapStyle = MapStyle.normal
        
        stub(mockRepository) { stub in
            when(stub).getMapStyle().thenReturn(expectedMapStyle)
        }
        
        let result = useCase.invoke()
        
        XCTAssertEqual(result, expectedMapStyle)
        verify(mockRepository).getMapStyle()
    }
}
