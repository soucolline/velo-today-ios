//
//  SettingsPresenterTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Cuckoo
import XCTest

@testable import velib_map

class SettingsPresenterTests: XCTestCase {
  private var mockPreferencesRepository: MockPreferencesRepository!
  private let mockSettingsView = MockSettingsView()
  private var presenter: SettingsPresenter!

  override func setUp() {
    stub(mockSettingsView) { stub in
      when(stub).onUpdateSegmentControl(for: any()).thenDoNothing()
    }

    mockPreferencesRepository = MockPreferencesRepository(with: UserDefaults.standard)
    presenter = SettingsPresenterImpl(preferencesRepository: mockPreferencesRepository)

    presenter.attach(mockSettingsView)
  }

  func testSetup() {
    let expectedMapStyle = MapStyle.normal

    stub(mockPreferencesRepository) { stub in
      when(stub).getMapStyle().thenReturn(expectedMapStyle)
    }

    presenter.setup()

    verify(mockSettingsView).onUpdateSegmentControl(for: equal(to: expectedMapStyle))
    verify(mockPreferencesRepository).getMapStyle()
    verifyNoMoreInteractions(mockSettingsView)
    verifyNoMoreInteractions(mockPreferencesRepository)
  }

  func testSetMapStyle() {
    let expectedMapStyle = MapStyle.normal

    stub(mockPreferencesRepository) { stub in
      when(stub).setMapStyle(identifier: any()).thenDoNothing()
    }

    presenter.setMapStyle(style: expectedMapStyle)

    verify(mockPreferencesRepository).setMapStyle(identifier: equal(to: expectedMapStyle.rawValue))
    verifyNoMoreInteractions(mockPreferencesRepository)
    verifyNoMoreInteractions(mockSettingsView)
  }

}
