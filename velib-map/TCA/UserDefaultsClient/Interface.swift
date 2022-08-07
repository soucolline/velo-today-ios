import ComposableArchitecture
import Foundation

public struct UserDefaultsClient {
  public var boolForKey: (String) -> Bool
  public var dataForKey: (String) -> Data?
  public var doubleForKey: (String) -> Double
  public var integerForKey: (String) -> Int
  public var stringForKey: (String) -> String?
  public var arrayForKey: (String) -> [String]?
  public var remove: (String) -> Effect<Never, Never>
  public var setBool: (Bool, String) -> Effect<Never, Never>
  public var setData: (Data?, String) -> Effect<Never, Never>
  public var setDouble: (Double, String) -> Effect<Never, Never>
  public var setInteger: (Int, String) -> Effect<Never, Never>
  public var setString: (String, String) -> Effect<Never, Never>
  public var setArray: ([String]?, String) -> Effect<Never, Never>

  public func isFavoriteStation(code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }
  
  func addFavoriteStation(for code: String) -> Effect<Never, Never> {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return .none }

    stations.append(code)
    
    return self.setArray(stations, Const.favoriteStationsId)
  }

  func removeFavoriteStations(for code: String) -> Effect<Never, Never> {
    var stations = self.getFavoriteStationsIds()

    guard stations.contains(code) else { return .none }

    stations.removeAll { $0 == code }
    
    return self.setArray(stations, Const.favoriteStationsId)
  }
  
  private func getFavoriteStationsIds() -> [String] {
    self.arrayForKey(Const.favoriteStationsId) ?? []
  }
  
  public var hasShownFirstLaunchOnboarding: Bool {
    self.boolForKey(hasShownFirstLaunchOnboardingKey)
  }

  public func setHasShownFirstLaunchOnboarding(_ bool: Bool) -> Effect<Never, Never> {
    self.setBool(bool, hasShownFirstLaunchOnboardingKey)
  }

  public var installationTime: Double {
    self.doubleForKey(installationTimeKey)
  }

  public func setInstallationTime(_ double: Double) -> Effect<Never, Never> {
    self.setDouble(double, installationTimeKey)
  }

  public func incrementMultiplayerOpensCount() -> Effect<Int, Never> {
    let incremented = self.integerForKey(multiplayerOpensCount) + 1
    return .concatenate(
      self.setInteger(incremented, multiplayerOpensCount).fireAndForget(),
      .init(value: incremented)
    )
  }
  
  private struct Const {
    static let favoriteStationsId = "favoriteStationsCode"
  }
}

let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
let installationTimeKey = "installationTimeKey"
let multiplayerOpensCount = "multiplayerOpensCount"
