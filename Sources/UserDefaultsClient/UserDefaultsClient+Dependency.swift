//
//  UserDefaultsClient+Dependency.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import Foundation
import Dependencies

enum UserDefaultsRepositoryKey: DependencyKey {
  static let liveValue: UserDefaultsRepository = UserDefaultsRepositoryImpl(
    userDefaults: UserDefaults(suiteName: "group.com.zlatan.velib-map")!
  )
}

public extension DependencyValues {
  var userDefaultsRepository: UserDefaultsRepository {
    get { self[UserDefaultsRepositoryKey.self] }
    set { self[UserDefaultsRepositoryKey.self] = newValue }
  }
}
