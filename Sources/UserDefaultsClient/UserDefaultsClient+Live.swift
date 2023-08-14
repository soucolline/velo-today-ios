import Foundation

extension UserDefaultsClient {
  public static func live(
    userDefaults: UserDefaults = UserDefaults.standard
  ) -> Self {
    Self(
      stringForKey: { userDefaults.string(forKey: $0) },
      arrayForKey: { userDefaults.stringArray(forKey: $0) },
      remove: { key in
          userDefaults.removeObject(forKey: key)
      },
      setBool: { value, key in
        userDefaults.set(value, forKey: key)
      },
      setData: { data, key in
        userDefaults.set(data, forKey: key)
      },
      setDouble: { value, key in
        userDefaults.set(value, forKey: key)
      },
      setInteger: { value, key in
        userDefaults.set(value, forKey: key)
      },
      setString: { value, key in
        userDefaults.set(value, forKey: key)
      },
      setArray: { value, key in
        userDefaults.set(value, forKey: key)
      },
      getAppVersion: {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
      }
    )
  }
}
