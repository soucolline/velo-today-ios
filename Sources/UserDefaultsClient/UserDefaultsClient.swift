import ComposableArchitecture
import Foundation

public struct UserDefaultsClient {
  public var boolForKey: (String) -> Bool
  public var dataForKey: (String) -> Data?
  public var doubleForKey: (String) -> Double
  public var integerForKey: (String) -> Int
  public var stringForKey: (String) -> String?
  public var arrayForKey: (String) -> [String]?
  public var remove: (String) -> EffectTask<Never>
  public var setBool: (Bool, String) -> EffectTask<Never>
  public var setData: (Data?, String) -> EffectTask<Never>
  public var setDouble: (Double, String) -> EffectTask<Never>
  public var setInteger: (Int, String) -> EffectTask<Never>
  public var setString: (String, String) -> EffectTask<Never>
  public var setArray: ([String]?, String) -> EffectTask<Never>
  public var getAppVersion: () -> String

  public func isFavoriteStation(code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }
  
  public func addFavoriteStation(for code: String) -> EffectTask<Never> {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return .none }

    stations.append(code)
    
    return self.setArray(stations, Const.favoriteStationsId)
  }

  public func removeFavoriteStations(for code: String) -> EffectTask<Never> {
    var stations = self.getFavoriteStationsIds()

    guard stations.contains(code) else { return .none }

    stations.removeAll { $0 == code }
    
    return self.setArray(stations, Const.favoriteStationsId)
  }
  
  private func getFavoriteStationsIds() -> [String] {
    self.arrayForKey(Const.favoriteStationsId) ?? []
  }
  
  private struct Const {
    static let favoriteStationsId = "favoriteStationsCode"
  }
}
