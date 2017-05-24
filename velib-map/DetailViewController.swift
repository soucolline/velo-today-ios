//
//  DetailViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 23/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var stackViewBtns: UIStackView!
  @IBOutlet weak var bikesLabel: UILabel!
  @IBOutlet weak var standsLabel: UILabel!
  @IBOutlet weak var lastUpdateLabel: UILabel!
  
  var currentStation: Station?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let screenHeight = UIScreen.main.bounds.height
    self.mapView.frame.size.height = screenHeight / 2
    self.mapView.delegate = self
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    if let station = self.currentStation {
      let coordinates = CLLocation(latitude: station.lat, longitude: station.lng)
      self.title = station.title ?? "N/A"
      self.mapView.addAnnotation(station)
      self.centerMapOnLocation(location: coordinates)
    }
    
    self.setupBtns()
    
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func setupBtns() {
    let _  = self.stackViewBtns.arrangedSubviews.map {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
    
    if let bikes = self.currentStation?.availableBikes, let stands = self.currentStation?.availableBikeStands {
      self.bikesLabel.text = "\(bikes) vélos disponibles"
      self.standsLabel.text = "\(stands) stands disponibles"
    }
    
    if let lastUpdate = self.currentStation?.lastUpdate {
      let date = Date(timeIntervalSince1970: TimeInterval(lastUpdate / 1000))
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone.current
      formatter.locale = Locale.current
      formatter.dateFormat =  "yyyy-MM-dd' à 'HH:mm"
      self.lastUpdateLabel.text = "Mis à jour le \(formatter.string(from: date))"
    }
    
  }
  
}

extension DetailViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? Station
      else { return nil }
    
    let identifier = "velibPin"
    let pin: MKAnnotationView
    var imageName = "pin"
    
    if annotation.status! == "CLOSED" {
      imageName = "pin-red"
    }
    
    if let deqeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
      deqeuedView.annotation = annotation
      pin = deqeuedView
    } else {
      pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }
    
    pin.image = UIImage(named: imageName)
    
    return pin
  }
  
}

