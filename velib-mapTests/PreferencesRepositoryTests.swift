//
//  PreferencesRepositoryTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest

@testable import velib_map

class PreferencesRepositoryTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var preferencesRepository: PreferencesRepository!

  private let mapStyleKey = "mapStyle"

  override func setUp() {
    userDefaults = UserDefaults(suiteName: #file)
    preferencesRepository = PreferencesRepository(with: self.userDefaults)
  }

  override func tearDown() {
    userDefaults.removePersistentDomain(forName: #file)
  }

  func testGetMapStyle() {
    var expectedIdentifier = "normalStyle"
    self.userDefaults.set(expectedIdentifier, forKey: mapStyleKey)

    XCTAssertEqual(self.preferencesRepository.getMapStyle(), MapStyle(rawValue: expectedIdentifier))

    expectedIdentifier = "hybridStyle"
    self.userDefaults.set(expectedIdentifier, forKey: mapStyleKey)
    XCTAssertEqual(self.preferencesRepository.getMapStyle(), MapStyle(rawValue: expectedIdentifier))

    expectedIdentifier = "satelliteStyle"
    self.userDefaults.set(expectedIdentifier, forKey: mapStyleKey)
    XCTAssertEqual(self.preferencesRepository.getMapStyle(), MapStyle(rawValue: expectedIdentifier))
  }

  func testSetMapStyle() {
    let expectedIdentifier = "normalStyle"

    self.preferencesRepository.setMapStyle(identifier: expectedIdentifier)

    XCTAssertEqual(self.userDefaults.string(forKey: mapStyleKey), expectedIdentifier)
  }

}
