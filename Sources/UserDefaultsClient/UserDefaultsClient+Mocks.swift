extension UserDefaultsClient {
  public static let noop = Self(
    stringForKey: { _ in nil },
    arrayForKey: { _ in nil },
    remove: { _ in },
    setBool: { _, _ in },
    setData: { _, _ in },
    setDouble: { _, _ in },
    setInteger: { _, _ in },
    setString: { _, _ in },
    setArray: { _, _ in },
    getAppVersion: { "123" }
  )
}

#if DEBUG
import Foundation
import XCTestDynamicOverlay

extension UserDefaultsClient {
  public static let failing = Self(
    stringForKey: { key in
      XCTFail("\(Self.self).stringForKey(\(key)) is unimplemented")
      return nil
    },
    arrayForKey: { key in
      XCTFail("\(Self.self).arrayForKey(\(key)) is unimplemented")
      return nil
    },
    remove: { key in unimplemented("\(Self.self).remove(\(key)) is unimplemented") },
    setBool: { _, key in unimplemented("\(Self.self).setBool(\(key), _) is unimplemented") },
    setData: { _, key in unimplemented("\(Self.self).setData(\(key), _) is unimplemented") },
    setDouble: { _, key in unimplemented("\(Self.self).setDouble(\(key), _) is unimplemented") },
    setInteger: { _, key in unimplemented("\(Self.self).setInteger(\(key), _) is unimplemented") },
    setString: { _, key in unimplemented("\(Self.self).setString(\(key), _) is unimplemented") },
    setArray: { _, key in unimplemented("\(Self.self).setArray(\(key), _) is unimplemented") },
    getAppVersion: { "\(Self.self).getAppVersion is not implemented" }
  )
}

extension UserDefaultsClientKey {
  static let testValue = UserDefaultsClient.noop
  static let previewValue = UserDefaultsClient.noop
}
#endif
