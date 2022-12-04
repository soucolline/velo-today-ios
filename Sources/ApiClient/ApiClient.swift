//
//  ApiClient.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Models

public struct ApiClient {
  public var fetchAllStations: @Sendable () async throws -> [Station]
}
