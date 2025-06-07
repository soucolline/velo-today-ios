//
//  ApiClient+Dependency.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import Foundation
import Dependencies

enum ApiClientKey: DependencyKey {
  static let liveValue = ApiClient.live
}

public extension DependencyValues {
  var apiClient: ApiClient {
    get { self[ApiClientKey.self] }
    set { self[ApiClientKey.self] = newValue }
  }
}

enum ApiClientProtocolKey: DependencyKey {
  static let liveValue: ApiClientProtocol = ApiClientImpl()
}

public extension DependencyValues {
  var apiClientProtocol: ApiClientProtocol {
    get { self[ApiClientProtocolKey.self] }
    set { self[ApiClientProtocolKey.self] = newValue }
  }
}
