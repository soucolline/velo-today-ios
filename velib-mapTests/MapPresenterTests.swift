//
//  MapPresenterTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 17/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import XCTest

@testable import velib_map

class MapPresenterTests: XCTestCase {
  private var mockMapView: MockMapViewDelegate!
  private var mockApiWorker: MockAPIWorker!
  private var mockMapService: MockMapService!
  private var mockPreferencesRepository: MockPreferencesRepository!

  private var presenter: MapPresenter!

  override func setUp() {
    self.mockMapView = MockMapViewDelegate()
    self.mockApiWorker = MockAPIWorker()
    self.mockMapService = MockMapService(with: self.mockApiWorker)
    self.mockPreferencesRepository = MockPreferencesRepository(with: UserDefaults.standard)

    stub(self.mockMapView) { stub in
      when(stub).onShowLoading().thenDoNothing()
      when(stub).onDismissLoading().thenDoNothing()
      when(stub).onCleanMap(with: any()).thenDoNothing()
      when(stub).onFetchStationsSuccess(stations: any()).thenDoNothing()
      when(stub).onFetchStationsErrorNotFound().thenDoNothing()
      when(stub).onFetchStationsErrorServerError().thenDoNothing()
      when(stub).onFetchStationsErrorCouldNotDecodeData().thenDoNothing()
    }

    stub(self.mockMapService) { stub in
      when(stub).fetchPins(completion: any()).thenDoNothing()
    }

    self.presenter = MapPresenterImpl(
      service: self.mockMapService,
      repository: self.mockPreferencesRepository
    )
    self.presenter.setView(view: self.mockMapView)
  }

  override func tearDown() {
    self.presenter.currentStation = nil
  }

  func testReloadPinsSuccess() {
    let expectedStations = [
      Station(freeDocks: 1, code: "sdhjsk", name: "test 1", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2]),
      Station(freeDocks: 1, code: "sdsjhdsk", name: "test 2", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2])
    ]
    let fetchPinsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins(completion: fetchPinsArgumentCaptor.capture())
    fetchPinsArgumentCaptor.value!(.success(expectedStations))
    verify(self.mockMapView).onFetchStationsSuccess(stations: ParameterMatcher(matchesFunction: { stations in
      stations == expectedStations
    }))
    verify(self.mockMapView).onDismissLoading()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testReloadPinsFailureNotFound() {
    let fetchPinsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins(completion: fetchPinsArgumentCaptor.capture())
    fetchPinsArgumentCaptor.value!(.failure(APIError.notFound))
    verify(self.mockMapView).onDismissLoading()
    verify(self.mockMapView).onFetchStationsErrorNotFound()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testReloadPinsFailureServerError() {
    let fetchPinsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins(completion: fetchPinsArgumentCaptor.capture())
    fetchPinsArgumentCaptor.value!(.failure(APIError.unknown))
    verify(self.mockMapView).onDismissLoading()
    verify(self.mockMapView).onFetchStationsErrorServerError()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testReloadPinsFailureCouldNotDecodeData() {
    let fetchPinsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins(completion: fetchPinsArgumentCaptor.capture())
    fetchPinsArgumentCaptor.value!(.failure(APIError.couldNotDecodeJSON))
    verify(self.mockMapView).onDismissLoading()
    verify(self.mockMapView).onFetchStationsErrorCouldNotDecodeData()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testGetMapStyle() {
    let expectedMapStyle = MapStyle.normal

    stub(self.mockPreferencesRepository) { stub in
      when(stub).getMapStyle().thenReturn(expectedMapStyle)
    }

    let mapStyle = self.presenter.getMapStyle()

    XCTAssertEqual(mapStyle, expectedMapStyle)
  }

  func testGetCurrentStation() {
    let expectedCurrentStation = Station(freeDocks: 1, code: "sdhjsk", name: "test 1", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2])

    self.presenter.currentStation = expectedCurrentStation

    XCTAssertEqual(expectedCurrentStation, self.presenter.getCurrentStation())
  }

}
