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
import Combine

@testable import velib_map

class MapPresenterTests: XCTestCase {
  private let mockMapView = MockMapView()
  private let mockURLFactory = MockURLFactory()
  private var mockApiWorker: MockAPIWorker!
  private var mockMapService: MockMapService!
  private let testNetworkScheduler = TestNetworkScheduler()
  private var mockPreferencesRepository: MockPreferencesRepository!

  private var presenter: MapPresenter!

  private let expectedStations = StubFixtures.StationsUtils.create()

  override func setUp() {
    self.mockApiWorker = MockAPIWorker()
    self.mockMapService = MockMapService(apiWorker: mockApiWorker, urlFactory: mockURLFactory)
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

    stub(mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Just(expectedStations).setFailureType(to: APIError.self).eraseToAnyPublisher())
    }

    self.presenter = MapPresenterImpl(
      service: mockMapService,
      repository: mockPreferencesRepository,
      networkScheduler: testNetworkScheduler
    )
    self.presenter.attach(mockMapView)
  }

  override func tearDown() {
    self.presenter.currentStation = nil
  }

  func testReloadPinsSuccess() {
    self.presenter.reloadPins()

    verify(mockMapView).onShowLoading()
    verify(mockMapView).onCleanMap(with: any())
    verify(mockMapService).fetchPins()
    verify(mockMapView).onFetchStationsSuccess(stations: ParameterMatcher(matchesFunction: { stations in
      stations == self.expectedStations
    }))
    verify(mockMapView).onDismissLoading()

    verifyNoMoreInteractions(mockMapView)
    verifyNoMoreInteractions(mockMapService)
    verifyNoMoreInteractions(mockPreferencesRepository)
  }

  func testReloadPinsFailureNotFound() {
    stub(mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Result.failure(APIError.notFound).publisher.eraseToAnyPublisher())
    }

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins()
    verify(self.mockMapView).onDismissLoading()
    verify(self.mockMapView).onFetchStationsErrorNotFound()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testReloadPinsFailureServerError() {
    stub(mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Result.failure(APIError.unknown).publisher.eraseToAnyPublisher())
    }

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins()
    verify(self.mockMapView).onDismissLoading()
    verify(self.mockMapView).onFetchStationsErrorServerError()

    verifyNoMoreInteractions(self.mockMapView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockPreferencesRepository)
  }

  func testReloadPinsFailureCouldNotDecodeData() {
    stub(mockMapService) { stub in
      when(stub).fetchPins().thenReturn(Result.failure(APIError.couldNotDecodeJSON).publisher.eraseToAnyPublisher())
    }

    self.presenter.reloadPins()

    verify(self.mockMapView).onShowLoading()
    verify(self.mockMapView).onCleanMap(with: any())
    verify(self.mockMapService).fetchPins()
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
    let expectedCurrentStation = StubFixtures.StationsUtils.create().first!

    self.presenter.currentStation = expectedCurrentStation

    XCTAssertEqual(expectedCurrentStation, self.presenter.getCurrentStation())
  }

}
