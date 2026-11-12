import MapKit
import Models
import SwiftUI
import UIKit

final class MapViewController: UIViewController, MKMapViewDelegate {
  var onReload: (() -> Void)?
  var onStationTapped: ((Station) -> Void)?

  private var annotations: [StationMarker] = []
  private var displayedCenter: MapLocation?
  private var displayedStations: [Station] = []
  private let loadingView = UIHostingController(rootView: LoaderView())
  private let mapView = MKMapView()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Stations disponibles"
    setupNavigationBar()
    setupMap()
    setupLoader()
  }

  func render(center: MapLocation, isLoading: Bool, stations: [Station], style: Models.MapStyle) {
    loadViewIfNeeded()

    switch style {
    case .normal: mapView.mapType = .standard
    case .hybrid: mapView.mapType = .hybrid
    case .satellite: mapView.mapType = .satellite
    }

    if displayedCenter != center {
      let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude),
        latitudinalMeters: 2_000,
        longitudinalMeters: 2_000
      )
      mapView.setRegion(region, animated: displayedCenter != nil)
      displayedCenter = center
    }

    if displayedStations != stations {
      mapView.removeAnnotations(annotations)
      annotations = stations.map { $0.toStationPin() }
      mapView.addAnnotations(annotations)
      displayedStations = stations
    }

    let alpha: CGFloat = isLoading ? 1 : 0
    if loadingView.view.alpha != alpha {
      UIView.animate(withDuration: 0.5) { self.loadingView.view.alpha = alpha }
    }
  }

  private func setupLoader() {
    addChild(loadingView)
    let loader = loadingView.view!
    loader.backgroundColor = .clear
    loader.translatesAutoresizingMaskIntoConstraints = false
    loader.isUserInteractionEnabled = false
    loader.alpha = 0
    view.addSubview(loader)
    NSLayoutConstraint.activate([
      loader.widthAnchor.constraint(equalToConstant: 300),
      loader.heightAnchor.constraint(equalToConstant: 100),
      loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loader.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
    ])
    loadingView.didMove(toParent: self)
  }

  private func setupNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "gobackward"),
      primaryAction: UIAction { [weak self] _ in self?.onReload?() }
    )
  }

  private func setupMap() {
    mapView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    mapView.delegate = self
    mapView.showsUserLocation = true
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? StationMarker else { return nil }

    let identifier = "velibPin"
    let pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
      ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    pin.annotation = annotation
    pin.canShowCallout = true
    pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    pin.glyphText = "\(annotation.station.freeBikes)"
    pin.markerTintColor = .orange
    pin.clusteringIdentifier = "mapCluster"
    return pin
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? StationMarker else { return }
    onStationTapped?(annotation.station)
  }
}
