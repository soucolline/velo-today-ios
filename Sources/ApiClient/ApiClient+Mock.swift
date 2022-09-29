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
    fetchStation: XCTUnimplemented("\(Self.self) fetchStation unimplemented"),
    fetchAllStations: XCTUnimplemented("\(Self.self) fetchAllStations unimplemented")
  )
}
#endif
