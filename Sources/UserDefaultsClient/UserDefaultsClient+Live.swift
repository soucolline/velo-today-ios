import Foundation

extension UserDefaultsClient {
  public static func live(
    userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.zlatan.velib-map")!
  ) -> Self {
    Self(
      boolForKey: userDefaults.bool(forKey:),
      dataForKey: userDefaults.data(forKey:),
      doubleForKey: userDefaults.double(forKey:),
      integerForKey: userDefaults.integer(forKey:),
      stringForKey: userDefaults.string(forKey:),
      arrayForKey: userDefaults.stringArray(forKey:),
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
