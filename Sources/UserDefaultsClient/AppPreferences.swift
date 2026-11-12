import Dependencies
import Foundation
import Sharing

public enum AppPreferences {
  // Keep the same domains and keys used by previous versions of the app.
  @MainActor private static let favoritesStore =
    UserDefaults(suiteName: "group.com.zlatan.velib-map")!

  @MainActor public static func favoriteCodes(store: UserDefaults? = nil) -> Shared<[String]> {
    Shared(wrappedValue: [], .appStorage("favoriteStationsCode", store: store ?? favoritesStore))
  }

  public static func mapStyle(store: UserDefaults? = nil) -> Shared<String> {
    Shared(wrappedValue: "normalStyle", .appStorage("mapStyle", store: store))
  }
}

private enum AppVersionKey: DependencyKey {
  static let liveValue: @Sendable () -> String = {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
  }
}

public extension DependencyValues {
  var appVersion: @Sendable () -> String {
    get { self[AppVersionKey.self] }
    set { self[AppVersionKey.self] = newValue }
  }
}
