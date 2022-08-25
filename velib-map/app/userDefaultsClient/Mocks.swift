extension UserDefaultsClient {
  public static let noop = Self(
    boolForKey: { _ in false },
    dataForKey: { _ in nil },
    doubleForKey: { _ in 0 },
    integerForKey: { _ in 0 },
    stringForKey: { _ in nil },
    arrayForKey: { _ in nil },
    remove: { _ in .none },
    setBool: { _, _ in .none },
    setData: { _, _ in .none },
    setDouble: { _, _ in .none },
    setInteger: { _, _ in .none },
    setString: { _, _ in .none },
    setArray: { _, _ in .none}
  )
}

#if DEBUG
  import Foundation
  import XCTestDynamicOverlay

  extension UserDefaultsClient {
    public static let failing = Self(
      boolForKey: { key
        in XCTFail("\(Self.self).boolForKey(\(key)) is unimplemented")
        return false
      },
      dataForKey: { key in
        XCTFail("\(Self.self).dataForKey(\(key)) is unimplemented")
        return nil
      },
      doubleForKey: { key in
        XCTFail("\(Self.self).doubleForKey(\(key)) is unimplemented")
        return 0
      },
      integerForKey: { key in
        XCTFail("\(Self.self).integerForKey(\(key)) is unimplemented")
        return 0
      },
      stringForKey: { key in
        XCTFail("\(Self.self).stringForKey(\(key)) is unimplemented")
        return nil
      },
      arrayForKey: { key in
        XCTFail("\(Self.self).arrayForKey(\(key)) is unimplemented")
        return nil
      },
      remove: { key in .failing("\(Self.self).remove(\(key)) is unimplemented") },
      setBool: { _, key in .failing("\(Self.self).setBool(\(key), _) is unimplemented") },
      setData: { _, key in .failing("\(Self.self).setData(\(key), _) is unimplemented") },
      setDouble: { _, key in .failing("\(Self.self).setDouble(\(key), _) is unimplemented") },
      setInteger: { _, key in .failing("\(Self.self).setInteger(\(key), _) is unimplemented") },
      setString: { _, key in .failing("\(Self.self).setString(\(key), _) is unimplemented") },
      setArray: { _, key in .failing("\(Self.self).setArray(\(key), _) is unimplemented") }
    )

    public mutating func override(bool: Bool, forKey key: String) {
      self.boolForKey = { [self] in $0 == key ? bool : self.boolForKey(key) }
    }

    public mutating func override(data: Data, forKey key: String) {
      self.dataForKey = { [self] in $0 == key ? data : self.dataForKey(key) }
    }

    public mutating func override(double: Double, forKey key: String) {
      self.doubleForKey = { [self] in $0 == key ? double : self.doubleForKey(key) }
    }

    public mutating func override(integer: Int, forKey key: String) {
      self.integerForKey = { [self] in $0 == key ? integer : self.integerForKey(key) }
    }
    
    public mutating func override(array: [String]?, forKey key: String) {
      self.arrayForKey = { [self] in $0 == key ? array : self.arrayForKey(key) }
    }
  }
#endif
