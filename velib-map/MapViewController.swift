//
//  MapViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 16/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var stations = [Station]()
  let initialLocation = CLLocation(latitude: 48.866667, longitude: 2.333333)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.mapView.delegate = self
    
    let response = Just.get(Api.stationFrom(.paris).url)
    if response.ok {
      let responseJSON = JSON(response.json as Any)
      
      let _ = responseJSON.map{ $0.1 }.map {
        let station = Mapper.mapStations(newsJSON: $0)
        self.stations.append(station)
      }
      self.centerMapOnLocation(location: self.initialLocation)
      self.showPins()
    } else {
      print("Something bad happened ==> \(String(describing: response.error?.localizedDescription))")
    }
    
  }
  
  func showPins() {
    let _ = self.stations.map{ self.mapView.addAnnotation($0) }
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 4000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? Station
      else { return nil }
    
    let identifier = "velibPin"
    let view: MKPinAnnotationView
    if let deqeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
      deqeuedView.annotation = annotation
      view = deqeuedView
    } else {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
    }
    
    return view
  }
}
