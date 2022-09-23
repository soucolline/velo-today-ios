//
//  FavoriteReducerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 25/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import ComposableArchitecture
import XCTest

@testable import velib_map

@MainActor
class FavoriteReducerTests: XCTestCase {
  func testFetchFavoriteStations_NoStations() {
    let store = TestStore(
      initialState: .init(
        isFetchStationRequestInFlight: true
      ),
      reducer: favoriteReducer,
      environment: .init(
        userDefaultsClient: .failing,
        apiClient: .unimplemented,
        mainQueue: DispatchQueue.test.eraseToAnyScheduler()
      )
    )
    
    store.environment.userDefaultsClient.arrayForKey = { _ in nil }
    
    store.send(.fetchFavoriteStations) {
      $0.stations = []
      $0.isFetchStationRequestInFlight = true
      $0.isFetchStationRequestInFlight = false
      $0.shouldShowEmptyView = true
    }
  }
  
  func testFetchFavoriteStations_Success() async {
    let store = TestStore(
      initialState: .init(),
      reducer: favoriteReducer,
      environment: .init(
        userDefaultsClient: .failing,
        apiClient: .unimplemented,
        mainQueue: DispatchQueue.test.eraseToAnyScheduler()
      )
    )
    
    let stationResponse1 = Station(
      freeDocks: 1,
      code: "123",
      name: "name1",
      totalDocks: 4,
      freeBikes: 5,
      freeMechanicalBikes: 6,
      freeElectricBikes: 7,
      geolocation: [1,2]
    )
    
    let stationResponse2 = Station(
      freeDocks: 1,
      code: "456",
      name: "name2",
      totalDocks: 12,
      freeBikes: 13,
      freeMechanicalBikes: 14,
      freeElectricBikes: 15,
      geolocation: [3,4]
    )
    
    store.environment.userDefaultsClient.arrayForKey = { _ in ["123", "456"] }
    store.environment.apiClient.fetchStation = { station in
      if station == "123" { return stationResponse1 }
      if station == "456" { return stationResponse2 }
      fatalError("should not happen")
    }
    
    await store.send(.fetchFavoriteStations) {
      $0.stations = []
      $0.isFetchStationRequestInFlight = true
    }
    
    await store.receive(.fetchFavoriteStationsResponse(.success([stationResponse1, stationResponse2]))) {
      $0.isFetchStationRequestInFlight = false
      $0.stations = [stationResponse1, stationResponse2]
    }
  }
  
  func testFetchFavoriteStations_Failure() async {
    let mainQueue = DispatchQueue.test
    let store = TestStore(
      initialState: .init(),
      reducer: favoriteReducer,
      environment: .init(
        userDefaultsClient: .failing,
        apiClient: .unimplemented,
        mainQueue: mainQueue.eraseToAnyScheduler()
      )
    )
    
    let error = "\(#file) test error"
    
    store.environment.userDefaultsClient.arrayForKey = { _ in ["123"] }
    store.environment.apiClient.fetchStation = { _ in throw error }
    
    await store.send(.fetchFavoriteStations) {
      $0.stations = []
      $0.isFetchStationRequestInFlight = true
    }
    
    await store.receive(.fetchFavoriteStationsResponse(.failure(error))) {
      $0.isFetchStationRequestInFlight = false
      $0.shouldShowError = true
    }
    
    await mainQueue.advance(by: 2)
    await store.receive(.hideErrorView) {
      $0.shouldShowError = false
    }
  }
}
