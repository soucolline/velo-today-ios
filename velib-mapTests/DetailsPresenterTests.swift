//
//  DetailsPresenterTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 17/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import XCTest

@testable import velib_map

class DetailsPresenterTests: XCTestCase {
  private var mockDetailsView: MockDetailsViewDelegate!
  private var mockFavoriteRepository: MockFavoriteRepository!
  private let expectedStation = Station(freeDocks: 1, code: "sdhjsk", name: "test 1", totalDocks: 2, freeBikes: 3, freeElectricBikes: 4, geo: [1, 2])

  private var presenter: DetailsPresenter!

  override func setUp() {
    self.mockDetailsView = MockDetailsViewDelegate()
    self.mockFavoriteRepository = MockFavoriteRepository(with: UserDefaults.standard)

    stub(self.mockDetailsView) { stub in
      when(stub).onAddFavoriteSuccess(numberOfFavoriteStations: any()).thenDoNothing()
      when(stub).onRemoveFavoriteSuccess(numberOfFavoriteStations: any()).thenDoNothing()
      when(stub).onAddFavoriteError().thenDoNothing()
      when(stub).onRemoveFavoriteError().thenDoNothing()
    }

    stub(self.mockFavoriteRepository) { stub in
      when(stub).isFavoriteStation(from: any()).thenReturn(true)
    }

    self.presenter = DetailsPresenterImpl(with: self.mockFavoriteRepository)
    self.presenter.setView(view: self.mockDetailsView)
  }

  func testSetDataWithStation() {
    self.presenter.setData(currentStation: self.expectedStation)

    verify(self.mockFavoriteRepository).isFavoriteStation(from: ParameterMatcher(matchesFunction: { code in
      code == self.expectedStation.code
    }))

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testSetDataWithoutStation() {
    self.presenter.setData(currentStation: nil)

    verify(self.mockFavoriteRepository, never()).isFavoriteStation(from: any())

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testAddFavoriteSuccess() {
    let expectedNumberOfFavoriteStations = 1

    self.presenter.setData(currentStation: self.expectedStation)

    stub(self.mockFavoriteRepository) { stub in
      when(stub).addFavoriteStation(for: any()).thenDoNothing()
      when(stub).getNumberOfFavoriteStations().thenReturn(expectedNumberOfFavoriteStations)
    }

    self.presenter.addFavorite()

    verify(self.mockFavoriteRepository).isFavoriteStation(from: ParameterMatcher(matchesFunction: { code in
      code == self.expectedStation.code
    }))
    verify(self.mockFavoriteRepository).addFavoriteStation(for: ParameterMatcher(matchesFunction: { code in
      code == self.expectedStation.code
    }))
    verify(self.mockDetailsView).onAddFavoriteSuccess(numberOfFavoriteStations: ParameterMatcher(matchesFunction: { numberOfFavoriteStations in
      numberOfFavoriteStations == expectedNumberOfFavoriteStations
    }))
    verify(self.mockFavoriteRepository).getNumberOfFavoriteStations()

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testAddFavoriteFailure() {
    self.presenter.setData(currentStation: nil)
    self.presenter.addFavorite()

    verify(self.mockDetailsView).onAddFavoriteError()

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testRemoveFavoriteSuccess() {
    let expectedNumberOfFavoriteStations = 1

    self.presenter.setData(currentStation: self.expectedStation)

    stub(self.mockFavoriteRepository) { stub in
      when(stub).removeFavoriteStations(for: any()).thenDoNothing()
      when(stub).getNumberOfFavoriteStations().thenReturn(expectedNumberOfFavoriteStations)
    }

    self.presenter.removeFavorite()

    verify(self.mockFavoriteRepository).isFavoriteStation(from: ParameterMatcher(matchesFunction: { code in
      code == self.expectedStation.code
    }))
    verify(self.mockFavoriteRepository).removeFavoriteStations(for: ParameterMatcher(matchesFunction: { code in
      code == self.expectedStation.code
    }))
    verify(self.mockDetailsView).onRemoveFavoriteSuccess(numberOfFavoriteStations: ParameterMatcher(matchesFunction: { numberOfFavoriteStations in
      numberOfFavoriteStations == expectedNumberOfFavoriteStations
    }))
    verify(self.mockFavoriteRepository).getNumberOfFavoriteStations()

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testRemoveFavoriteFailure() {
    self.presenter.setData(currentStation: nil)
    self.presenter.removeFavorite()

    verify(self.mockDetailsView).onRemoveFavoriteError()

    verifyNoMoreInteractions(self.mockDetailsView)
    verifyNoMoreInteractions(self.mockFavoriteRepository)
  }

  func testGetCurrentStations() {
    self.presenter.setData(currentStation: self.expectedStation)

    XCTAssertEqual(self.presenter.getCurrentStation(), self.expectedStation)
  }

  func testGetCurrentStationTitle() {
    self.presenter.setData(currentStation: self.expectedStation)

    XCTAssertEqual(self.presenter.getCurrentStationTitle(), self.expectedStation.name)
  }

  func testGetCurrentStationLocation() {
    self.presenter.setData(currentStation: self.expectedStation)

    XCTAssertEqual(self.presenter.getCurrentStationLocation(), self.expectedStation.location)
  }

  func testIsFavoriteStation() {
    self.presenter.setData(currentStation: self.expectedStation)

    XCTAssertTrue(self.presenter.isFavoriteStation())

    self.presenter.setData(currentStation: nil)

    XCTAssertFalse(self.presenter.isFavoriteStation())
  }

}
