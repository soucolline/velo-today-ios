//
//  APIWorkerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import XCTest
import Cuckoo

@testable import velib_map

class APIWorkerTests: XCTestCase {
  
  var sessionMock: MockNetworkSession!
  var apiWorker: APIWorker!
  var stubStationsData: Data!
  
  override func setUp() {
    sessionMock = MockNetworkSession()
    apiWorker = APIWorkerImpl(with: sessionMock)
    
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.url(forResource: "fetchAll", withExtension: "json")!
    self.stubStationsData = try! Data(contentsOf:  path)
  }
  
  func testLoadDataSuccess() {
    let expectedURL = URL(string: "https://www.fake-url.com")!
    
    stub(sessionMock) { stub in
      when(stub).loadData(from: any(), completionHandler: any()).then({ url, completionHandler in
        completionHandler(self.stubStationsData, nil)
      })
    }
    
    apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:], completion: { result in
      verify(self.sessionMock).loadData(from: ParameterMatcher(matchesFunction: { url in
        url == expectedURL
      }), completionHandler: any())
      
      XCTAssertEqual(try! result.get().records.first?.station.code, "17026")
      XCTAssertEqual(try! result.get().records.first?.station.freeDocks, 32)
      XCTAssertEqual(try! result.get().records.first?.station.name, "Jouffroy d'Abbans - Wagram")
      XCTAssertEqual(try! result.get().records.first?.station.totalDocks, 0)
      XCTAssertEqual(try! result.get().records.first?.station.freeBikes, 5)
      XCTAssertEqual(try! result.get().records.first?.station.geo, [48.881973298351625, 2.301132157444954])
    })
    
    verifyNoMoreInteractions(sessionMock)
  }
  
  
  func testLoadDataFailedCustomError() {
    let expectedURL = URL(string: "https://www.fake-url.com")!

    stub(sessionMock) { stub in
      when(stub).loadData(from: any(), completionHandler: any()).then({ url, completionHandler in
        completionHandler(nil, APIError.couldNotDecodeJSON)
      })
    }

    apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:], completion: { result in
      verify(self.sessionMock).loadData(from: ParameterMatcher(matchesFunction: { url in
        url == expectedURL
      }), completionHandler: any())

      _ = result.mapError { error -> APIError in
        XCTAssertEqual(error, APIError.customError(error.localizedDescription))

        return error
      }
    })

    verifyNoMoreInteractions(sessionMock)
  }

  func testLoadDataFailedNoData() {
    let expectedURL = URL(string: "https://www.fake-url.com")!

    stub(sessionMock) { stub in
      when(stub).loadData(from: any(), completionHandler: any()).then({ url, completionHandler in
        completionHandler(nil, nil)
      })
    }

    apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:], completion: { result in
      verify(self.sessionMock).loadData(from: ParameterMatcher(matchesFunction: { url in
        url == expectedURL
      }), completionHandler: any())

      _ = result.mapError { error -> APIError in
        XCTAssertEqual(error, APIError.noData)

        return error
      }
    })

    verifyNoMoreInteractions(sessionMock)
  }

  func testLoadDataFailedCouldNotDecodeJSON() {
    let expectedURL = URL(string: "https://www.fake-url.com")!
    let dataToFail = "///".data(using: .utf8)

    stub(sessionMock) { stub in
      when(stub).loadData(from: any(), completionHandler: any()).then({ url, completionHandler in
        completionHandler(dataToFail, nil)
      })
    }

    apiWorker.request(for: FetchStationObjectResponseRoot.self, at: expectedURL, method: .get, parameters: [:], completion: { result in
      verify(self.sessionMock).loadData(from: ParameterMatcher(matchesFunction: { url in
        url == expectedURL
      }), completionHandler: any())

      _ = result.mapError { error -> APIError in
        XCTAssertEqual(error, APIError.couldNotDecodeJSON)

        return error
      }
    })

    verifyNoMoreInteractions(sessionMock)
  }
  
}

