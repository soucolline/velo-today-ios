import Foundation

public protocol UserDefaultsRepository: Sendable {
  func array(for key: String) -> [String]
  func getAppVersion() -> String
  func isFavoriteStation(code: String) -> Bool
  func addFavoriteStation(for code: String)
  func removeFavoriteStations(for code: String)
}

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository, @unchecked Sendable {
  private let userDefaults: UserDefaults
  
  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }
  
  public func array(for key: String) -> [String] {
    userDefaults.stringArray(forKey: key) ?? []
  }
  
  public func getAppVersion() -> String {
    Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
  }
  
  public func isFavoriteStation(code: String) -> Bool {
    self.getFavoriteStationsIds().contains(code)
  }
  
  public func addFavoriteStation(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard !stations.contains(code) else { return }

    stations.append(code)
    
    return self.set(array: stations, for: Const.favoriteStationsId)
  }

  public func removeFavoriteStations(for code: String) {
    var stations = self.getFavoriteStationsIds()

    guard stations.contains(code) else { return }

    stations.removeAll { $0 == code }
    
    return self.set(array: stations, for: Const.favoriteStationsId)
  }
  
  private func getFavoriteStationsIds() -> [String] {
    self.array(for: Const.favoriteStationsId)
  }
  
  private func set(array: [String]?, for key: String) {
    userDefaults.set(array, forKey: key)
  }
  
  private func remove(key: String) {
    userDefaults.removeObject(forKey: key)
  }
  
  private struct Const {
    static let favoriteStationsId = "favoriteStationsCode"
  }
}
