//
//  SettingsReducerTests.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 25/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import ComposableArchitecture
import XCTest
import SettingsFeature
import Models

class SettingsReducerTests: XCTestCase {
  @MainActor
  func testOnAppear() async {
    @Shared(.appStorage("mapStyle")) var mapStyleUserDefaults: String = "hybridStyle"
    
    let store = TestStore(
      initialState: .init(),
      reducer: { SettingsReducer() }
    )
    
    store.dependencies.userDefaultsClient.getAppVersion = { "123" }
    
    await store.send(.onAppear) {
      $0.mapStyle = .hybrid
      $0.selectedPickerIndex = MapStyle.hybrid.pickerValue
      $0.appVersion = "123"
    }
  }
  
  @MainActor
  func testSelectedPickerIndexBinding() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { SettingsReducer() }
    )
    
    await store.send(\.binding.selectedPickerIndex, 2) {
      $0.selectedPickerIndex = 2
      $0.mapStyle = .satellite
      $0.mapStyleUserDefaults = "satelliteStyle"
    }
  }
}
