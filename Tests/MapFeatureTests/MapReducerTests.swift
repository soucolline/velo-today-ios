//
//  MapReducerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 25/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import XCTest
import ComposableArchitecture
import MapFeature
import Models

class MapReducerTests: XCTestCase {
  @MainActor
  func testFetchAllStations_Success() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { MapReducer() }
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
    
    store.dependencies.apiClient.fetchAllStations = { [station] }
    
    await store.send(.fetchAllStations) {
      $0.shouldShowLoader = true
    }
    await store.receive(\.fetchAllStationsResponse.success) {
      $0.stations = [station]
      $0.hasAlreadyLoadedStations = true
      $0.shouldShowLoader = false
    }
  }
  
  @MainActor
  func testFetchAllStations_Failure() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { MapReducer() }
    )
    
    let error = "test failed"
    store.dependencies.apiClient.fetchAllStations = { throw error }
    
    await store.send(.fetchAllStations) {
      $0.shouldShowLoader = true
    }
    await store.receive(\.fetchAllStationsResponse.failure) {
      $0.hasAlreadyLoadedStations = true
      $0.shouldShowError = true
      $0.shouldShowLoader = false
    }
  }
  
  @MainActor
  func testGetMapStyle() async {
    @Shared(.appStorage("mapStyle")) var mapStyleUserDefaults = "hybridStyle"
    
    let store = TestStore(
      initialState: .init(),
      reducer: { MapReducer() }
    )
    
    await store.send(.getMapStyle) {
      $0.mapStyle = .hybrid
    }
  }
  
  @MainActor
  func testHideError() async {
    let store = TestStore(
      initialState: .init(shouldShowError: true),
      reducer: { MapReducer() }
    )
    
    await store.send(.hideError) {
      $0.shouldShowError = false
    }
  }
}
