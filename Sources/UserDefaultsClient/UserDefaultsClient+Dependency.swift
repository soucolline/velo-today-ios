//
//  UserDefaultsClient+Dependency.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import Foundation
import Dependencies

enum UserDefaultsClientKey: DependencyKey {
  static let liveValue = UserDefaultsClient.live()
}

public extension DependencyValues {
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClientKey.self] }
    set { self[UserDefaultsClientKey.self] = newValue }
  }
}
