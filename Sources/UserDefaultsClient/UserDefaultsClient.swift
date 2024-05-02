import ComposableArchitecture
import Foundation

public struct UserDefaultsClient {
  public var boolForKey: (String) -> Bool
  public var dataForKey: (String) -> Data?
  public var doubleForKey: (String) -> Double
  public var integerForKey: (String) -> Int
  public var stringForKey: (String) -> String?
  public var arrayForKey: (String) -> [String]?
  public var remove: (String) -> Void
  public var setBool: (Bool, String) -> Void
  public var setData: (Data?, String) -> Void
  public var setDouble: (Double, String) -> Void
  public var setInteger: (Int, String) -> Void
  public var setString: (String, String) -> Void
  public var setArray: ([String]?, String) -> Void
  public var getAppVersion: () -> String

  public func isFavoriteStation(code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }
  
  public func addFavoriteStation(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return }

    stations.append(code)
    
    return self.setArray(stations, Const.favoriteStationsId)
  }

  public func removeFavoriteStations(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard stations.contains(code) else { return }

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
