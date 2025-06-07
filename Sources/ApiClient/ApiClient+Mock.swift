//
//  File.swift
//  
//
//  Created by Thomas Guilleminot on 23/09/2022.
//

import Foundation

#if DEBUG
import XCTestDynamicOverlay

extension ApiClient {
  public static let noop = Self(
    fetchAllStations: unimplemented("\(Self.self) fetchAllStations unimplemented")
  )
}

extension ApiClientKey {
  static let testValue = ApiClient.noop
  static let previewValue = ApiClient.noop
}

#endif
