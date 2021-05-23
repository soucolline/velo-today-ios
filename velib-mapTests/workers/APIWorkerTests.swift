//
//  APIWorkerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import XCTest
import Cuckoo
import Combine

@testable import velib_map

class APIWorkerTests: XCTestCase {
  
  private let sessionMock = MockNetworkSession()
  private var apiWorker: APIWorker!
  private var stubStationsData: Data!
  private let expectedURL = URL(string: "https://www.fake-url.com")!
  private let expectedStation = StubFixtures.FetchStationObjectResponseRootUtils.create()

  private var cancelable: AnyCancellable?

  override func setUp() {
    apiWorker = APIWorkerImpl(with: sessionMock)
  }
  
  func testLoadDataSuccess() {
    let expectedURLResponse = HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let expectedPublisher = Just((data: try! JSONEncoder().encode(expectedStation), response: expectedURLResponse as URLResponse)).setFailureType(to: URLError.self).eraseToAnyPublisher()
    
    stub(sessionMock) { stub in
      when(stub).loadData(from: any()).thenReturn(expectedPublisher)
    }

    cancelable = apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:]).sink { completion in
      switch completion {
        case .finished: break
        case .failure: XCTFail("Should not trigger failure")
      }
    } receiveValue: { response in
      XCTAssertEqual(response.records.first?.station.code, "17026")
      XCTAssertEqual(response.records.first?.station.freeDocks, 32)
      XCTAssertEqual(response.records.first?.station.name, "Jouffroy d'Abbans - Wagram")
      XCTAssertEqual(response.records.first?.station.totalDocks, 0)
      XCTAssertEqual(response.records.first?.station.freeBikes, 5)
      XCTAssertEqual(response.records.first?.station.geo, [48.881973298351625, 2.301132157444954])
    }

    verify(sessionMock).loadData(from: ParameterMatcher(matchesFunction: { url in
      url == self.expectedURL
    }))
    verifyNoMoreInteractions(sessionMock)
  }

  func testLoadDataFailureNoResponse() {
    let forecastData = try! JSONEncoder().encode(expectedStation)
    let expectedURLResponse = URLResponse()
    let expectedPublisher = Just((data: forecastData, response: expectedURLResponse)).setFailureType(to: URLError.self).eraseToAnyPublisher()

    stub(sessionMock) { stub in
      when(stub).loadData(from: any()).thenReturn(expectedPublisher)
    }

    cancelable = apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:]).sink { completion in
      switch completion {
        case .finished: break
        case .failure(let error): XCTAssertEqual(error, APIError.urlNotValid)
      }
    } receiveValue: { forecast in
      XCTFail("Should not trigger success")
    }

    verify(sessionMock).loadData(from: any())
    verifyNoMoreInteractions(sessionMock)
  }

  func testLoadDataFailure404() {
    let forecastData = try! JSONEncoder().encode(expectedStation)
    let expectedURLResponse = HTTPURLResponse(url: expectedURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
    let expectedPublisher = Just((data: forecastData, response: expectedURLResponse as URLResponse)).setFailureType(to: URLError.self).eraseToAnyPublisher()

    stub(sessionMock) { stub in
      when(stub).loadData(from: any()).thenReturn(expectedPublisher)
    }

    cancelable = apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:]).sink { completion in
      switch completion {
        case .finished: break
        case .failure(let error): XCTAssertEqual(error, APIError.noData)
      }
    } receiveValue: { forecast in
      XCTFail("Should not trigger success")
    }

    verify(sessionMock).loadData(from: any())
    verifyNoMoreInteractions(sessionMock)
  }

  func testLoadDataFailureJSONDecode() {
    let wrongData = "{id: 12}".data(using: .utf8)!
    let expectedURLResponse = HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let expectedPublisher = Just((data: wrongData, response: expectedURLResponse as URLResponse)).setFailureType(to: URLError.self).eraseToAnyPublisher()

    stub(sessionMock) { stub in
      when(stub).loadData(from: any()).thenReturn(expectedPublisher)
    }

    cancelable = apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:]).sink { completion in
      switch completion {
        case .finished: break
        case .failure(let error): XCTAssertEqual(error, APIError.couldNotDecodeJSON)
      }
    } receiveValue: { forecast in
      XCTFail("Should not trigger success")
    }

    verify(sessionMock).loadData(from: any())
    verifyNoMoreInteractions(sessionMock)
  }
  
}

