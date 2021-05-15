//
//  MapServiceTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import Combine
import XCTest

@testable import velib_map

class MapServiceTests: XCTestCase {
  private let mockApiWorker = MockAPIWorker()
  private let mockURLFactory = MockURLFactory()
  private var mapService: MapService!

  private let expectedURL = URL(string: "https://www.fake.com")!

  override func setUp() {
    stub(mockURLFactory) { stub in
      when(stub).createFetchPinsUrl().thenReturn(expectedURL)
      when(stub).createFetchStation(from: any()).thenReturn(expectedURL)
    }

    mapService = MapService(apiWorker: mockApiWorker, urlFactory: mockURLFactory)
  }

  func testFetchPins() {
    let expectedResponse = StubFixtures.FetchStationObjectResponseRootUtils.create()
    let expectedPublisher = Just(expectedResponse).setFailureType(to: APIError.self).eraseToAnyPublisher()

    stub(mockApiWorker) { stub in
      when(stub).request(for: any(), at: any(), method: any(), parameters: any()).thenReturn(expectedPublisher)
    }

    _ = mapService.fetchPins().sink(receiveCompletion: { completion in
      switch completion {
        case .finished: break
        case .failure: XCTFail("Should not fail")
      }
    }, receiveValue: { result in
      XCTAssertEqual(result, expectedResponse.records.map { $0.station })
    })

    verify(mockURLFactory).createFetchPinsUrl()
    verify(mockApiWorker).request(for: ParameterMatcher(matchesFunction: { (_: FetchStationObjectResponseRoot.Type) in true
    }), at: equal(to: expectedURL), method: equal(to: HTTPMethod.get), parameters: any())
    verifyNoMoreInteractions(mockURLFactory)
    verifyNoMoreInteractions(mockApiWorker)
  }

  func testFetchAllStations() {
    let expectedIds = ["1", "2"]
    let expectedFirstUrl = URL(string: "https:www.number\(expectedIds.first!).com")!
    let expectedSecondUrl = URL(string: "https:www.number\(expectedIds.last!).com")!
    let expectedFirstResponse = StubFixtures.FetchStationObjectResponseRootUtils.create()
    let expectedSecondResponse = StubFixtures.FetchStationObjectResponseRootUtils.createSecond()
    let expectedFirstPublisher = Just(expectedFirstResponse).setFailureType(to: APIError.self).eraseToAnyPublisher()
    let expectedSecondPublisher = Just(expectedSecondResponse).setFailureType(to: APIError.self).eraseToAnyPublisher()

    stub(mockURLFactory) { stub in
      when(stub).createFetchStation(from: expectedIds.first!).thenReturn(expectedFirstUrl)
      when(stub).createFetchStation(from: expectedIds.last!).thenReturn(expectedSecondUrl)
    }

    stub(mockApiWorker) { stub in
      when(stub).request(for: any(), at: equal(to: expectedFirstUrl), method: any(), parameters: any()).thenReturn(expectedFirstPublisher)
      when(stub).request(for: any(), at: equal(to: expectedSecondUrl), method: any(), parameters: any()).thenReturn(expectedSecondPublisher)
    }

    _ = mapService.fetchAllStations(from: expectedIds).sink(receiveCompletion: { completion in
      switch completion {
        case .finished: break
        case .failure: XCTFail("Should not fail")
      }
    }, receiveValue: { stations in
      XCTAssertEqual(stations.first!.code, "17026")
      XCTAssertEqual(stations.first!.freeDocks, 32)
      XCTAssertEqual(stations.first!.name, "Jouffroy d'Abbans - Wagram")
      XCTAssertEqual(stations.first!.totalDocks, 0)
      XCTAssertEqual(stations.first!.freeBikes, 5)
      XCTAssertEqual(stations.first!.geo, [48.881973298351625, 2.301132157444954])

      XCTAssertEqual(stations.last!.code, "12346")
      XCTAssertEqual(stations.last!.freeDocks, 11)
      XCTAssertEqual(stations.last!.name, "Asnière Gare")
      XCTAssertEqual(stations.last!.totalDocks, 2)
      XCTAssertEqual(stations.last!.freeBikes, 3)
      XCTAssertEqual(stations.last!.geo, [22.2369368721, 22.2367232])
    })

    verify(mockURLFactory).createFetchStation(from: expectedIds[0])
    verify(mockURLFactory).createFetchStation(from: expectedIds[1])
    verify(mockApiWorker).request(for: ParameterMatcher(matchesFunction: { (_: FetchStationObjectResponseRoot.Type) in true
    }), at: equal(to: expectedFirstUrl), method: equal(to: HTTPMethod.get), parameters: any())
    verify(mockApiWorker).request(for: ParameterMatcher(matchesFunction: { (_: FetchStationObjectResponseRoot.Type) in true
    }), at: equal(to: expectedSecondUrl), method: equal(to: HTTPMethod.get), parameters: any())
    verifyNoMoreInteractions(mockURLFactory)
    verifyNoMoreInteractions(mockApiWorker)
  }
}
