//
//  MapPresenterTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import XCTest
import Cuckoo
import Promises

@testable import velib_map
@testable import Promises

class MapPresenterTests: XCTestCase {
  
  var mockMapViewDelegate: MockMapViewDelegate!
  var mockMapService: MockMapService!
  var mockAPIWorker: MockAPIWorker!
  var mockPreferencesRepository: MockPreferencesRepository!
  var presenter: MapPresenter!
  
  override func setUp() {
    self.mockMapViewDelegate = MockMapViewDelegate()
    self.mockAPIWorker = MockAPIWorker()
    self.mockMapService = MockMapService(with: self.mockAPIWorker)
    self.mockPreferencesRepository = MockPreferencesRepository(with: UserDefaults.standard)
    
    self.presenter = MapPresenterImpl(service: self.mockMapService, repository: self.mockPreferencesRepository)
    self.presenter.setView(view: self.mockMapViewDelegate)
    
    stub(self.mockMapViewDelegate) { stub in
      when(stub).onShowLoading().thenDoNothing()
      when(stub).onCleanMap(with: any()).thenDoNothing()
      when(stub).onDismissLoading().thenDoNothing()
      when(stub).onFetchStationsSuccess(stations: any(Array<Station>.self)).thenDoNothing()
      when(stub).onFetchStationsErrorNotFound().thenDoNothing()
      when(stub).onFetchStationsErrorServerError().thenDoNothing()
      when(stub).onFetchStationsErrorCouldNotDecodeData().thenDoNothing()
    }
  }
  
  func testReloadPinsSuccess() {
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.url(forResource: "fetchAll", withExtension: "json")!
    let stubStationsData = try! Data(contentsOf:  path)
    let station = try! JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: stubStationsData).records.first?.station
    
    stub(self.mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Promise([station!]))
    }
    
    self.presenter.reloadPins()
    
    verify(self.mockMapViewDelegate).onShowLoading()
    verify(self.mockMapViewDelegate).onCleanMap(with: any())
    
    verify(self.mockMapService).fetchPins()
    
    _ = waitForPromises(timeout: 1)
    
    verify(self.mockMapViewDelegate).onFetchStationsSuccess(stations: ParameterMatcher(matchesFunction: { localStation in
      localStation.first == station
    }))
    verify(self.mockMapViewDelegate).onDismissLoading()
    
    verifyNoMoreInteractions(self.mockMapViewDelegate)
    verifyNoMoreInteractions(self.mockMapService)
  }
  
  func testReloadServerError() {
    stub(self.mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Promise(APIError.internalServerError))
    }
    
    self.presenter.reloadPins()
    
    verify(self.mockMapViewDelegate).onShowLoading()
    verify(self.mockMapViewDelegate).onCleanMap(with: any())
    
    verify(self.mockMapService).fetchPins()
    
    _ = waitForPromises(timeout: 3)
    
    verify(self.mockMapViewDelegate).onDismissLoading()
    verify(self.mockMapViewDelegate).onFetchStationsErrorServerError()
    
    verifyNoMoreInteractions(self.mockMapViewDelegate)
    verifyNoMoreInteractions(self.mockMapService)
  }
  
  func testReloadNotFoundError() {
    stub(self.mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Promise(APIError.notFound))
    }
    
    self.presenter.reloadPins()
    
    verify(self.mockMapViewDelegate).onShowLoading()
    verify(self.mockMapViewDelegate).onCleanMap(with: any())
    
    verify(self.mockMapService).fetchPins()
    
    _ = waitForPromises(timeout: 3)
    
    verify(self.mockMapViewDelegate).onDismissLoading()
    verify(self.mockMapViewDelegate).onFetchStationsErrorNotFound()
    
    verifyNoMoreInteractions(self.mockMapViewDelegate)
    verifyNoMoreInteractions(self.mockMapService)
  }
  
  func testReloadCouldNotDecodeError() {
    stub(self.mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Promise(APIError.couldNotDecodeJSON))
    }
    
    self.presenter.reloadPins()
    
    verify(self.mockMapViewDelegate).onShowLoading()
    verify(self.mockMapViewDelegate).onCleanMap(with: any())
    
    verify(self.mockMapService).fetchPins()
    
    _ = waitForPromises(timeout: 3)
    
    verify(self.mockMapViewDelegate).onDismissLoading()
    verify(self.mockMapViewDelegate).onFetchStationsErrorCouldNotDecodeData()
    
    verifyNoMoreInteractions(self.mockMapViewDelegate)
    verifyNoMoreInteractions(self.mockMapService)
  }
  
  func testGetMapStyle() {
    stub(self.mockPreferencesRepository) { stub in
      when(stub).getMapStyle().thenReturn(MapStyle.normal)
    }
    
    XCTAssertEqual(self.presenter.getMapStyle(), MapStyle.normal)
  }
  
  func testGetCurrentStation() {
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.url(forResource: "fetchAll", withExtension: "json")!
    let stubStationsData = try! Data(contentsOf:  path)
    let station = try! JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: stubStationsData).records.first?.station
    
    self.presenter.currentStation = station
    
    XCTAssertEqual(self.presenter.getCurrentStation(), station)
  }
  
}
