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
  func testOnAppear() {
    let store = TestStore(
      initialState: .init(),
      reducer: SettingsReducer()
    )
    
    store.dependencies.userDefaultsClient.stringForKey = { _ in "hybridStyle" }
    store.dependencies.userDefaultsClient.getAppVersion = { "123" }
    
    store.send(.onAppear) {
      $0.mapStyle = .hybrid
      $0.selectedPickerIndex = MapStyle.hybrid.pickerValue
      $0.appVersion = "123"
    }
  }
  
  func testSelectedPickerIndexBinding() {
    let store = TestStore(
      initialState: .init(),
      reducer: SettingsReducer()
    )
    
    store.dependencies.userDefaultsClient.setString = { _, _ in .none }
    
    store.send(.set(\.$selectedPickerIndex, 2)) {
      $0.selectedPickerIndex = 2
      $0.mapStyle = .satellite
    }
  }
}
