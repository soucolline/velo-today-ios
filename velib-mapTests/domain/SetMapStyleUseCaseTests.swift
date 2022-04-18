//
//  SetMapStyleUseCaseTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 09/04/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import velib_map

class SetMapStyleUseCaseTests: XCTestCase {
    private let mockRepository = MockMapRepository()
    private var useCase: SetMapStyleUseCase!
    
    override func setUp() {
        useCase = SetMapStyleUseCase(mapRepository: mockRepository)
    }
    
    override func tearDown() {
        verifyNoMoreInteractions(mockRepository)
    }
    
    func testInvoke() {
        let expectedIdentifier = "testIdentifier"
        
        stub(mockRepository) { stub in
            when(stub).setMapStyle(identifier: any()).thenDoNothing()
        }
        
        useCase.invoke(identifier: expectedIdentifier)
        
        verify(mockRepository).setMapStyle(identifier: expectedIdentifier)
    }
}
