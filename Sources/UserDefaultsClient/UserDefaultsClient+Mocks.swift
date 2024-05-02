extension UserDefaultsClient {
  public static let noop = Self(
    arrayForKey: { _ in nil },
    remove: { _ in },
    setArray: { _, _ in },
    getAppVersion: { "123" }
  )
}

#if DEBUG
import Foundation
import XCTestDynamicOverlay

extension UserDefaultsClient {
  public static let failing = Self(
    arrayForKey: { key in
      XCTFail("\(Self.self).arrayForKey(\(key)) is unimplemented")
      return nil
    },
    remove: { key in unimplemented() },
    setArray: { _, key in unimplemented() },
    getAppVersion: { unimplemented() }
  )

  public mutating func override(array: [String]?, forKey key: String) {
    self.arrayForKey = { [self] in $0 == key ? array : self.arrayForKey(key) }
  }
}

extension UserDefaultsClientKey {
  static let testValue = UserDefaultsClient.noop
  static let previewValue = UserDefaultsClient.noop
}

#endif
