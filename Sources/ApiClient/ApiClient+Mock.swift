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
  public static let unimplemented = Self(
    fetchAllStations: XCTUnimplemented("\(Self.self) fetchAllStations unimplemented")
  )
}

extension ApiClientKey {
  static let testValue = ApiClient.unimplemented
  static let previewValue = ApiClient.unimplemented
}

#endif
