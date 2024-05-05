//
//  MapViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 22/09/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import UIKit
import MapKit
import CoreLocation
import Combine
import SwiftUI
import Models
import DetailsFeature

class MapViewController: UIViewController {
  @IBOutlet private var reloadBtn: UIBarButtonItem!
  
  @Perception.Bindable var store: StoreOf<MapReducer>
  var cancellables: Set<AnyCancellable> = []
  
  private var mapView: MKMapView!
  private var loadingView = UIHostingController<LoaderView>(rootView: LoaderView())

  var loaderMessage = "Chargement des stations"
  
  let initialLocation = CLLocation(latitude: 48.866667, longitude: 2.333333)
  let locationManager = CLLocationManager()
  
  init(store: StoreOf<MapReducer>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Stations disponibles"
    
    setupNavigationBar()
    setupMap()
    setupLoader()
    
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    self.locationManager.requestLocation()
    
    setupViews()
    
    self.store.send(.fetchAllStations)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.store.send(.getMapStyle)
  }
  
  func setupViews() {
    observe { [weak self] in
      guard let self else { return }
      
      switch self.store.mapStyle {
      case .normal:
        self.mapView.mapType = .standard
      case .hybrid:
        self.mapView.mapType = .hybrid
      case .satellite:
        self.mapView.mapType = .satellite
      }
      
      if self.store.shouldShowLoader {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
          self.loadingView.view.alpha = 1.0
        }
      } else {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
          self.loadingView.view.alpha = 0.0
        }
      }
      
      if self.store.shouldShowError {
        let alert = UIAlertController(
          title: "Erreur",
          message: self.store.errorText,
          preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
          self.store.send(.hideError)
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
      }
    }
    
    observe { [weak self] in
      guard let self else { return }
      if let store = self.store.scope(state: \.details, action: \.showDetails) {
        let detailView = UIHostingController(rootView: DetailsView(store: store))
        
        detailView.presentationController?.delegate = self
        if let sheet = detailView.sheetPresentationController {
          sheet.detents = [.medium()]
          sheet.prefersScrollingExpandsWhenScrolledToEdge = true
          sheet.prefersEdgeAttachedInCompactHeight = true
          sheet.preferredCornerRadius = 12
        }
        self.present(detailView, animated: true)
      } else {
        self.dismiss(animated: true)
      }
    }
    
    self.store.publisher.stations
      .sink(receiveValue: { stations in
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(stations.map { $0.toStationPin() })
      })
      .store(in: &cancellables)
  }
  
  func setupLoader() {
    self.loadingView.view.backgroundColor = .clear
    self.loadingView.view.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
    self.loadingView.view.center = view.center
    self.loadingView.view.center.y -= self.loadingView.view.frame.height / 2
    self.loadingView.view.alpha = 0.0
    
    self.view.addSubview(loadingView.view)
  }
  
  func setupNavigationBar() {
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithOpaqueBackground()
    
    let reloadButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(reloadPins))
    
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    self.navigationItem.rightBarButtonItem = reloadButton
  }
  
  func setupMap() {
    self.mapView = MKMapView()
    view.insertSubview(self.mapView, at: 0)
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = false
    self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    
    self.mapView.delegate = self
    self.mapView.showsUserLocation = true
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius * 2.0,
      longitudinalMeters: regionRadius * 2.0
    )
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
  @objc private func reloadPins() {
    self.store.send(.fetchAllStations)
  }
  
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? StationMarker else { return nil }
    
    let identifier = "velibPin"
    let pin: MKMarkerAnnotationView
    
    if let deqeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
      deqeuedView.annotation = annotation
      pin = deqeuedView
    } else {
      pin = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pin.canShowCallout = true
      pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
    }

    pin.glyphText = "\(annotation.freeBikes)"
    pin.markerTintColor = UIColor.orange
    pin.clusteringIdentifier = "mapCluster"
    
    return pin
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let station = view.annotation as? StationMarker else { return }
    
    store.send(.stationPinTapped(station))
  }
  
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = manager.location else { return }
    
    self.centerMapOnLocation(location: location)
    self.locationManager.stopUpdatingLocation()
    self.locationManager.delegate = nil
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.centerMapOnLocation(location: self.initialLocation)
  }
  
}

extension MapViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    store.send(.hideDetails)
  }
}
