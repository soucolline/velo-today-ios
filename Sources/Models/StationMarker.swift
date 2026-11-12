import MapKit

@MainActor
public final class StationMarker: NSObject, @preconcurrency MKAnnotation {
  public let station: Station
  public var coordinate: CLLocationCoordinate2D { station.coordinate }
  public var title: String? { station.name }

  public init(station: Station) {
    self.station = station
  }
}
