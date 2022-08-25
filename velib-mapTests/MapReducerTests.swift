//
//  MapReducerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 25/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import XCTest
import ComposableArchitecture

@testable import velib_map

@MainActor
class MapReducerTests: XCTestCase {
  func testFetchAllStations_Success() async {
    let store = TestStore(
      initialState: .init(),
      reducer: mapReducer,
      environment: .init(
        apiClient: .unimplemented
      )
    )
    
    let station = Station(
      freeDocks: 1,
      code: "123",
      name: "name",
      totalDocks: 4,
      freeBikes: 5,
      freeMechanicalBikes: 6,
      freeElectricBikes: 7,
      geolocation: [1, 2]
    )
    
    store.environment.apiClient.fetchAllStations = { [station] }
    
    await store.send(.fetchAllStations)
    await store.receive(.fetchAllStationsResponse(.success([station]))) {
      $0.stations = [station]
      $0.hasAlreadyLoadedStations = true
    }
  }
  
  func testFetchAllStations_Failure() async {
    let store = TestStore(
      initialState: .init(),
      reducer: mapReducer,
      environment: .init(
        apiClient: .unimplemented
      )
    )
    
    let error = "test failed"
    store.environment.apiClient.fetchAllStations = { throw error }
    
    await store.send(.fetchAllStations)
    await store.receive(.fetchAllStationsResponse(.failure(error))) {
      $0.hasAlreadyLoadedStations = true
    }
  }
}
