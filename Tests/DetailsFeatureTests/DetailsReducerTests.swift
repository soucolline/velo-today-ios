//
//  DetailsReducerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 25/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import ComposableArchitecture
import XCTest
import Models
import DetailsFeature
import MapKit

class DetailsReducerTests: XCTestCase {
  private let station = StationMarker(
    freeDocks: 1,
    code: "123",
    name: "name",
    totalDocks: 4,
    freeBikes: 5,
    freeMechanicalBikes: 6,
    freeElectricBikes: 7,
    geolocation: [1, 2]
  )
  
  @MainActor
  func testOnAppear() async {
    let store = TestStore(
      initialState: .init(
        station: station
      ),
      reducer: { DetailsReducer() }
    )
    
    store.dependencies.userDefaultsClient.override(array: ["123"], forKey: "favoriteStationsCode")
    
    await store.send(.onAppear) {
      $0.title = self.station.name
      $0.stationLocation = MKCoordinateRegion(
        center: self.station.coordinate,
        latitudinalMeters: 200,
        longitudinalMeters: 200
      )
      $0.isFavoriteStation = true
    }
  }
  
  @MainActor
  func testFavoriteButtonTapped_Favorite() async {
    let store = TestStore(
      initialState: .init(
        isFavoriteStation: true
      ),
      reducer: { DetailsReducer() }
    )
    
    store.dependencies.userDefaultsClient.arrayForKey = { _ in [] }
    
    await store.send(.favoriteButtonTapped) {
      $0.isFavoriteStation = false
    }
  }
  
  @MainActor
  func testFavoriteButtonTapped_NotFavorite() async {
    let store = TestStore(
      initialState: .init(
        isFavoriteStation: false
      ),
      reducer: { DetailsReducer() }
    )
    
    store.dependencies.userDefaultsClient.arrayForKey = { _ in [] }
    store.dependencies.userDefaultsClient.setArray = { _, _ in }
    
    await store.send(.favoriteButtonTapped) {
      $0.isFavoriteStation = true
    }
  }
}
