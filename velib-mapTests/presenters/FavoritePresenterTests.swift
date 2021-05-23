//
//  FavoritePresenterTests.swift
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

class FavoritePresenterTests: XCTestCase {
  private let mockFavoriteView = MockFavoriteView()
  private var mockApiWorker = MockAPIWorker()
  private var mockMapService: MockMapService!
  private let mockURLFactory = MockURLFactory()
  private var mockFavoriteRepository: MockFavoriteRepository!
  private let testNetworkScheduler = TestNetworkScheduler()

  private var presenter: FavoritePresenter!

  private let expectedStations = StubFixtures.StationsUtils.create()

  override func setUp() {
    self.mockMapService = MockMapService(apiWorker: mockApiWorker, urlFactory: mockURLFactory)
    self.mockFavoriteRepository = MockFavoriteRepository(with: UserDefaults.standard)

    stub(mockFavoriteView) { stub in
      when(stub).onFetchStationsSuccess().thenDoNothing()
      when(stub).onFetchStationsEmptyError().thenDoNothing()
      when(stub).onFetchStationsError().thenDoNothing()
      when(stub).onShowLoading().thenDoNothing()
      when(stub).onDismissLoading().thenDoNothing()
    }

    stub(mockMapService) { stub in
      when(stub).fetchAllStations(from: any()).thenReturn(Just(expectedStations).setFailureType(to: APIError.self).eraseToAnyPublisher())
    }

    self.presenter = FavoritePresenterImpl(
      mapService: mockMapService,
      favoriteRepository: mockFavoriteRepository,
      networkScheduler: testNetworkScheduler
    )
    self.presenter.attach(mockFavoriteView)
  }

  func testFetchFavoriteStationsSuccess() {
    let expectedStationsIds = [self.expectedStations.first!.code, self.expectedStations.last!.code]

    stub(self.mockFavoriteRepository) { stub in
      when(stub).getFavoriteStationsIds().thenReturn(expectedStationsIds)
    }

    self.presenter.fetchFavoriteStations()

    verify(self.mockFavoriteRepository).getFavoriteStationsIds()
    verify(self.mockFavoriteView).onShowLoading()
    verify(self.mockMapService).fetchAllStations(from: expectedStationsIds)
    verify(self.mockFavoriteView).onFetchStationsSuccess()
    verify(self.mockFavoriteView).onDismissLoading()

    verifyNoMoreInteractions(self.mockFavoriteView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testFetchFavoriteStationsWithNoFavoriteStations() {
    stub(self.mockFavoriteRepository) { stub in
      when(stub).getFavoriteStationsIds().thenReturn([])
    }

    self.presenter.fetchFavoriteStations()

    verify(self.mockFavoriteView).onShowLoading()
    verify(self.mockFavoriteRepository).getFavoriteStationsIds()
    verify(self.mockFavoriteView).onDismissLoading()
    verify(self.mockFavoriteView).onFetchStationsEmptyError()

    verifyNoMoreInteractions(self.mockFavoriteView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testFetchFavoriteStationsFailure() {
    let expectedStationsIds = [self.expectedStations.first!.code, self.expectedStations.last!.code]

    stub(self.mockFavoriteRepository) { stub in
      when(stub).getFavoriteStationsIds().thenReturn(expectedStationsIds)
    }

    stub(mockMapService) { stub in
      when(stub).fetchAllStations(from: any()).thenReturn(Result.failure(APIError.internalServerError).publisher.eraseToAnyPublisher())
    }

    self.presenter.fetchFavoriteStations()

    verify(self.mockFavoriteRepository).getFavoriteStationsIds()
    verify(self.mockFavoriteView).onShowLoading()
    verify(self.mockMapService).fetchAllStations(from: expectedStationsIds)
    verify(self.mockFavoriteView).onDismissLoading()
    verify(self.mockFavoriteView).onFetchStationsError()

    verifyNoMoreInteractions(self.mockFavoriteView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }
}
