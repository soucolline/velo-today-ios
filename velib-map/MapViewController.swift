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
import MBProgressHUD

class MapViewController: UIViewController, VelibEventBus {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var reloadBtn: UIBarButtonItem! {
    didSet {
      let icon = UIImage(named: "reload")
      let iconSize = CGRect(origin: CGPoint(x: 0,y :0), size: icon!.size)
      let iconButton = UIButton(frame: iconSize)
      iconButton.setBackgroundImage(icon, for: .normal)
      iconButton.setBackgroundImage(icon, for: .highlighted)
      reloadBtn.customView = iconButton
    }
  }
  
  let interactor = VelibInteractor()
  var stations = [Station]()
  var currentStation: Station?
  let initialLocation = CLLocation(latitude: 48.866667, longitude: 2.333333)
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Velibs"
    
    VelibPresenter.register(self, events: .fetchPinsSuccess, .failure)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(reloadPins))
    self.reloadBtn.customView?.addGestureRecognizer(tap)
    
    self.mapView.delegate = self
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    self.locationManager.requestLocation()
    
    self.reloadPins()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setMapStyle()
  }
  
  deinit {
    VelibPresenter.unregisterAll(self)
  }
  
  func fetchPinsSuccess(stations: [Station]) {
    MBProgressHUD.hide(for: self.view, animated: true)
    self.stations = stations
    let _ = self.stations.map { self.mapView.addAnnotation($0) }
  }
  
  func failure(error: String) {
    self.present(PopupManager.errorPopup(message: "Impossible de recuperer les informations des stations"), animated: true)
  }
  
  func setMapStyle() {
    let defaults = UserDefaults.standard
    guard let mapStyle = defaults.value(forKey: "mapStyle") as? String
      else { return }
    
    switch mapStyle {
      case "normalStyle":
        self.mapView.mapType = .standard
      case "hybridStyle":
        self.mapView.mapType = .hybrid
      case "satelliteStyle":
        self.mapView.mapType = .satellite
      default:
        self.mapView.mapType = .standard
    }
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func reloadPins() {
    let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
    loader.label.text = "Downloading pins"
    
    self.mapView.removeAnnotations(self.stations)
    self.stations.removeAll()
    
    self.animateReloadBtn()
    self.interactor.fetchPins()
  }
  
  func animateReloadBtn() {
    UIView.animate(withDuration: 0.5, animations: {
      self.reloadBtn.customView?.transform =
        CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    })
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
      self.reloadBtn.customView?.transform =
        CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detailStationSegue" {
      let vc = segue.destination as? DetailViewController
      vc?.currentStation = self.currentStation
    }
  }
  
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? Station
      else { return nil }
    
    let identifier = "velibPin"
    let pin: MKAnnotationView
    var imageName = ""
    
    if let bikes = annotation.availableBikes {
      imageName = "pin-\(bikes)"
    }
    
    if annotation.status! == "CLOSED" {
      imageName = "pin-red"
    }
    
    if let deqeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
      deqeuedView.annotation = annotation
      pin = deqeuedView
    } else {
      pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pin.canShowCallout = true
      pin.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
    }
    
    pin.image = UIImage(named: imageName)
    
    return pin
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let station = view.annotation as? Station
    self.currentStation = station
    self.performSegue(withIdentifier: "detailStationSegue", sender: self)
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = manager.location
      else { return }
    
    self.centerMapOnLocation(location: location)
    self.locationManager.stopUpdatingLocation()
    self.locationManager.delegate = nil
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.centerMapOnLocation(location: self.initialLocation)
  }
}
