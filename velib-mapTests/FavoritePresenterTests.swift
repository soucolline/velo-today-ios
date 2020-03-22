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

@testable import velib_map

class FavoritePresenterTests: XCTestCase {
  private var mockFavoriteView: MockFavoriteViewDeletage!
  private var mockApiWorker: MockAPIWorker!
  private var mockMapService: MockMapService!
  private var mockFavoriteRepository: MockFavoriteRepository!

  private var presenter: FavoritePresenter!

  private let expectedStations = [
    Station(freeDocks: 1, code: "sdhjsk", name: "test 1", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2]),
    Station(freeDocks: 1, code: "sdsjhdsk", name: "test 2", totalDocks: 6, freeBikes: 34, freeMechanicalBikes: 4, freeElectricBikes: 24, geo: [32, 222]),
    Station(freeDocks: 1, code: "sdsjhdsk", name: "test 3", totalDocks: 43, freeBikes: 23, freeMechanicalBikes: 4, freeElectricBikes: 334, geo: [10, 20])
  ]

  override func setUp() {
    self.mockFavoriteView = MockFavoriteViewDeletage()
    self.mockApiWorker = MockAPIWorker()
    self.mockMapService = MockMapService(with: self.mockApiWorker)
    self.mockFavoriteRepository = MockFavoriteRepository(with: UserDefaults.standard)

    stub(self.mockFavoriteView) { stub in
      when(stub).onFetchStationsSuccess().thenDoNothing()
      when(stub).onFetchStationsEmptyError().thenDoNothing()
      when(stub).onFetchStationsError().thenDoNothing()
      when(stub).onShowLoading().thenDoNothing()
      when(stub).onDismissLoading().thenDoNothing()
    }

    stub(self.mockMapService) { stub in
      when(stub).fetchAllStations(from: any(), completion: any()).thenDoNothing()
    }

    self.presenter = FavoritePresenterImpl(
      with: self.mockMapService,
      favoriteRepository: self.mockFavoriteRepository
    )
    self.presenter.setView(view: self.mockFavoriteView)
  }

  func testFetchFavoriteStationsSuccess() {
    let fetchAllStationsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()
    let expectedStationsIds = [self.expectedStations.first!.code, self.expectedStations.last!.code]

    stub(self.mockFavoriteRepository) { stub in
      when(stub).getFavoriteStationsIds().thenReturn(expectedStationsIds)
    }

    self.presenter.fetchFavoriteStations()

    verify(self.mockFavoriteRepository).getFavoriteStationsIds()
    verify(self.mockFavoriteView).onShowLoading()
    verify(self.mockMapService).fetchAllStations(from: any(), completion: fetchAllStationsArgumentCaptor.capture())
    fetchAllStationsArgumentCaptor.value!(.success(expectedStations))
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
    let fetchAllStationsArgumentCaptor = ArgumentCaptor<(Result<[Station], APIError>) -> Void>()
    let expectedStationsIds = [self.expectedStations.first!.code, self.expectedStations.last!.code]

    stub(self.mockFavoriteRepository) { stub in
      when(stub).getFavoriteStationsIds().thenReturn(expectedStationsIds)
    }

    self.presenter.fetchFavoriteStations()

    verify(self.mockFavoriteRepository).getFavoriteStationsIds()
    verify(self.mockFavoriteView).onShowLoading()
    verify(self.mockMapService).fetchAllStations(from: any(), completion: fetchAllStationsArgumentCaptor.capture())
    fetchAllStationsArgumentCaptor.value!(.failure(APIError.notFound))
    verify(self.mockFavoriteView).onDismissLoading()
    verify(self.mockFavoriteView).onFetchStationsError()

    verifyNoMoreInteractions(self.mockFavoriteView)
    verifyNoMoreInteractions(self.mockMapService)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }
}
