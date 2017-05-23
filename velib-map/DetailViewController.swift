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
    
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)
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

