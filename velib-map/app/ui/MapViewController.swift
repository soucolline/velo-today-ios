//
//  MapViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Swinject
import SwiftUI

class MapViewController: UIViewController {
  
  @IBOutlet private var mapView: MKMapView!
  @IBOutlet private var reloadBtn: UIBarButtonItem!

  private var presenter: MapPresenter = Assembler.inject(MapPresenter.self)

  var loaderMessage = "Chargement des stations"
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override var prefersStatusBarHidden: Bool {
    false
  }
  
  let initialLocation = CLLocation(latitude: 48.866667, longitude: 2.333333)
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Stations disponibles"
    
    self.mapView.delegate = self
    self.mapView.showsUserLocation = true
    
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    self.locationManager.requestLocation()
    
    self.presenter.attach(self)
    self.presenter.reloadPins()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setMapStyle()
  }

  func setMapStyle() {
    switch self.presenter.getMapStyleForDisplay() {
    case .normal:
      self.mapView.mapType = .standard
    case .hybrid:
      self.mapView.mapType = .hybrid
    case .satellite:
      self.mapView.mapType = .satellite
    }
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
  
  @IBAction private func reloadPins(_ sender: UIBarButtonItem) {
    self.presenter.reloadPins()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.SegueIdentifiers.detailSegue {
      let vc = segue.destination as? DetailsViewController
      vc?.currentStation = self.presenter.getCurrentStation()
    }
  }
  
}

extension MapViewController: MapView {
  
  func onCleanMap(with stations: [UIStation]) {
    self.mapView.removeAnnotations(stations)
  }
  
  func onFetchStationsSuccess(stations: [UIStation]) {
    DispatchQueue.main.async {
      stations.forEach { self.mapView.addAnnotation($0) }
    }
  }
  
  func onFetchStationsErrorNotFound() {
    DispatchQueue.main.async {
      self.present(PopupManager.showErrorPopup(message: "Impossible de trouver de stations, veuillez réessayer"), animated: true)
    }
  }
  
  func onFetchStationsErrorServerError() {
    DispatchQueue.main.async {
      self.present(PopupManager.showErrorPopup(message: "Une erreur est survenue, veuillez réessayer"), animated: true)
    }
  }
  
  func onFetchStationsErrorCouldNotDecodeData() {
    DispatchQueue.main.async {
      self.present(PopupManager.showErrorPopup(message: "Impossible de décoder les données"), animated: true)
    }
  }
  
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? UIStation else { return nil }
    
    let identifier = K.Identifiers.velibPin
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
    pin.markerTintColor = K.Colors.orange
    pin.clusteringIdentifier = K.Identifiers.mapCluster
    
    return pin
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let station = view.annotation as? UIStation
    self.presenter.currentStation = station
    self.performSegue(withIdentifier: K.SegueIdentifiers.detailSegue, sender: self)
  //  self.navigationController?.pushViewController(UIHostingController(rootView: DetailsViewTCA()), animated: true)
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
