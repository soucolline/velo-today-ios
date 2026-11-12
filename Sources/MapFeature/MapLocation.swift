import ComposableArchitecture
import CoreLocation

public struct MapLocation: Equatable, Sendable {
  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  static let paris = Self(latitude: 48.866667, longitude: 2.333333)
}

private enum MapLocationKey: DependencyKey {
  static let liveValue: @MainActor @Sendable () async -> MapLocation? = {
    let request = LocationRequest()
    return await request.location()
  }
}

public extension DependencyValues {
  var mapLocation: @MainActor @Sendable () async -> MapLocation? {
    get { self[MapLocationKey.self] }
    set { self[MapLocationKey.self] = newValue }
  }
}

@MainActor
private final class LocationRequest: NSObject, @preconcurrency CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private let result = AsyncStream<MapLocation>.makeStream()
  private var hasRequestedLocation = false

  func location() async -> MapLocation? {
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    manager.delegate = self
    defer { manager.delegate = nil }

    var iterator = result.stream.makeAsyncIterator()
    return await iterator.next()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      guard !hasRequestedLocation else { return }
      hasRequestedLocation = true
      manager.requestLocation()
    case .denied, .restricted:
      result.continuation.finish()
    @unknown default:
      result.continuation.finish()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let coordinate = locations.last?.coordinate {
      result.continuation.yield(MapLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
    result.continuation.finish()
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    result.continuation.finish()
  }
}
