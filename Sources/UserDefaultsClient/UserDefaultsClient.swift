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
  public var getAppVersion: () -> String

  public func isFavoriteStation(code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }
  
  public func addFavoriteStation(for code: String) -> Effect<Never, Never> {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return .none }

    stations.append(code)
    
    return self.setArray(stations, Const.favoriteStationsId)
  }

  public func removeFavoriteStations(for code: String) -> Effect<Never, Never> {
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
