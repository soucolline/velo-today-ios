import Foundation

extension UserDefaultsClient {
  public static func live(
    userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.zlatan.velib-map")!
  ) -> Self {
    Self(
      arrayForKey: userDefaults.stringArray(forKey:),
      remove: { key in
          userDefaults.removeObject(forKey: key)
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
