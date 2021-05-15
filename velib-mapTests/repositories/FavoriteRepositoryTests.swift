//
//  FavoriteRepositoryTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 14/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import Foundation
import XCTest

@testable import velib_map

class FavoriteRepositoryTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var favoriteRepository: FavoriteRepository!

  private let favoriteStationsIdKey = "favoriteStationsCode"

  override func setUp() {
    userDefaults = UserDefaults(suiteName: #file)
    favoriteRepository = FavoriteRepository(with: self.userDefaults)
  }

  override func tearDown() {
    userDefaults.removePersistentDomain(forName: #file)
  }

  func testGetFavoriteStationsIds() {
    let expectedIds = ["123", "456", "2363"]

    self.userDefaults.set(expectedIds, forKey: favoriteStationsIdKey)

    XCTAssertEqual(self.favoriteRepository.getFavoriteStationsIds(), expectedIds)
  }

  func testAddFavoriteStation() {
    let expectedFirstCode = "123"
    let expectedSecondCode = "456"

    self.favoriteRepository.addFavoriteStation(for: expectedFirstCode)
    XCTAssertEqual(self.userDefaults.array(forKey: favoriteStationsIdKey)?.count, 1)

    self.favoriteRepository.addFavoriteStation(for: expectedSecondCode)
    XCTAssertEqual(self.userDefaults.array(forKey: favoriteStationsIdKey)?.count, 2)

    self.favoriteRepository.addFavoriteStation(for: expectedSecondCode)
    XCTAssertEqual(self.userDefaults.array(forKey: favoriteStationsIdKey)?.count, 2)

    let codes = self.userDefaults.array(forKey: favoriteStationsIdKey) as! [String]
    XCTAssertEqual(codes.first, expectedFirstCode)
    XCTAssertEqual(codes.last, expectedSecondCode)
  }

  func testRemoveFavoriteStation() {
    let expectedFirstCode = "123"
    let expectedSecondCode = "456"

    self.userDefaults.set([expectedFirstCode, expectedSecondCode], forKey: favoriteStationsIdKey)

    XCTAssertEqual(self.userDefaults.array(forKey: favoriteStationsIdKey)?.count, 2)

    self.favoriteRepository.removeFavoriteStations(for: expectedFirstCode)

    let codes = self.userDefaults.array(forKey: favoriteStationsIdKey) as! [String]
    XCTAssertEqual(codes.count, 1)
    XCTAssertEqual(codes.first, expectedSecondCode)

    self.favoriteRepository.removeFavoriteStations(for: expectedFirstCode)
    XCTAssertEqual(self.userDefaults.array(forKey: favoriteStationsIdKey)?.count, 1)
  }

  func testIsFavoriteStation() {
    let expectedId = "123"
    self.userDefaults.set([expectedId], forKey: favoriteStationsIdKey)

    XCTAssertTrue(self.favoriteRepository.isFavoriteStation(from: expectedId))
    XCTAssertFalse(self.favoriteRepository.isFavoriteStation(from: "4343"))
  }

  func testGetNumberOfFavoriteStations() {
    let expectedIds = ["123", "4523", "23", "2367"]
    self.userDefaults.set(expectedIds, forKey: favoriteStationsIdKey)

    XCTAssertEqual(self.favoriteRepository.getNumberOfFavoriteStations(), expectedIds.count)
  }
}
