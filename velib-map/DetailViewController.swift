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
import CoreStore

class DetailViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var stackViewBtns: UIStackView!
  @IBOutlet weak var bikesLabel: UILabel!
  @IBOutlet weak var standsLabel: UILabel!
  @IBOutlet weak var lastUpdateLabel: UILabel!
  @IBOutlet weak var favBtn: UIButton!
  
  var currentStation: Station!
  var isFavStation: FavoriteStation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.isFavStation = CoreStore.fetchOne(From<FavoriteStation>(), Where("number", isEqualTo: self.currentStation.number))
    
    self.title = self.currentStation.title ?? "N/A"
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    // Set mapview size
    let screenHeight = UIScreen.main.bounds.height
    self.mapView.frame.size.height = screenHeight / 2
    self.mapView.delegate = self
    self.mapView.addAnnotation(self.currentStation)
    
    self.setupBtns()
    self.updateFavBtn()
    self.centerMapOnLocation(location: self.currentStation.location)
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func setupBtns() {
    guard let station = self.currentStation
      else { return }
    
    // Add corner radius
    let _  = self.stackViewBtns.arrangedSubviews.map {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
    
    self.bikesLabel.text = "\(station.availableBikes ?? 0) vélos disponibles"
    self.standsLabel.text = "\(station.availableBikeStands ?? 0) stands disponibles"
    self.lastUpdateLabel.text = station.lastUpdateDateString
  }
  
  func updateFavBtn() {
    if isFavStation != nil {
      self.favBtn.backgroundColor = UIColor.colorFromInteger(color: 0xD91E18)
      self.favBtn.setTitle("Supprimer des favoris", for: .normal)
    } else {
      self.favBtn.backgroundColor = UIColor.colorFromInteger(color: 0x3FC380)
      self.favBtn.setTitle("Ajouter aux favoris", for: .normal)
    }
  }
  
  @IBAction func toggleFavorite(_ sender: UIButton) {
    guard let station = self.currentStation
      else { return }
    
    if self.isFavStation == nil {
      CoreStore.perform(asynchronous: { transaction in
        let favStation = transaction.create(Into<FavoriteStation>())
        favStation.number = Int32(station.number!)
        favStation.availableBikes = Int16(station.availableBikes!)
        favStation.availableBikeStands = Int16(station.availableBikeStands!)
        favStation.name = station.name
        favStation.address = station.address
        self.isFavStation = favStation
      }, completion: { result in
        let favStationsCount = CoreStore.fetchCount(From<FavoriteStation>())
        print("number of favorite stations ==> \(favStationsCount ?? -1)")
        self.updateFavBtn()
      })
    } else {
      let currentFav = CoreStore.fetchOne(From<FavoriteStation>(), Where("number", isEqualTo: station.number))
      CoreStore.perform(asynchronous: { transaction in
        transaction.delete(currentFav)
      }, completion: { result in
        let favStationsCount = CoreStore.fetchCount(From<FavoriteStation>())
        print("number of favorite stations ==> \(favStationsCount ?? -1)")
        self.isFavStation = nil
        self.updateFavBtn()
      })
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

