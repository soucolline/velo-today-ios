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
import ZLogger

class DetailViewController: UIViewController, VelibEventBus {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var stackViewBtns: UIStackView!
  @IBOutlet weak var bikesLabel: UILabel!
  @IBOutlet weak var standsLabel: UILabel!
  @IBOutlet weak var lastUpdateLabel: UILabel!
  @IBOutlet weak var favBtn: UIButton!
  @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
  
  let interactor = VelibInteractor()
  var currentStation: Station!
  var isFavStation: FavoriteStation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = self.currentStation.title ?? "N/A"
    
    VelibPresenter.register(observer: self, events: .addFavoriteSuccess, .removeFavoriteSuccess, .failure)
    
    self.isFavStation = CoreStore.fetchOne(From<FavoriteStation>().where(format: "number", self.currentStation.number as Any))
    
    // Set mapview size
    self.mapHeightConstraint.constant = self.setMapHeight()
    self.mapView.delegate = self
    self.mapView.addAnnotation(self.currentStation)
    
    self.setupBtns()
    self.centerMapOnLocation(location: self.currentStation.location)
    self.isFavStation == nil
      ? self.updateFavBtn(with: 0x3FC380, andTitle: "Ajouter aux favoris")
      : self.updateFavBtn(with: 0xD91E18, andTitle: "Supprimer des favoris")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    VelibPresenter.unregisterAll(observer: self)
  }
  
  func setMapHeight() -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    return screenHeight == 568.0 ? screenHeight / 3 : screenHeight / 2
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
    _ = self.stackViewBtns.arrangedSubviews.map {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
    
    self.bikesLabel.text = "\(station.availableBikes ?? 0) vélos disponibles"
    self.standsLabel.text = "\(station.availableBikeStands ?? 0) stands disponibles"
    self.lastUpdateLabel.text = station.lastUpdateDateString
  }
  
  func updateFavBtn(with color: UInt32, andTitle title: String) {
    self.favBtn.backgroundColor = UIColor.colorFromInteger(color: color)
    self.favBtn.setTitle(title, for: .normal)
  }
  
  @IBAction func toggleFavorite(_ sender: UIButton) {
    guard let station = self.currentStation
      else { return }
    
    self.isFavStation == nil
      ? self.interactor.addFavorite(station: station)
      : self.interactor.removeFavorite(station: station)
  }
  
  func addFavoriteSuccess(favoriteStation: FavoriteStation) {
    self.isFavStation = favoriteStation
    let favStationsCount = CoreStore.fetchCount(From<FavoriteStation>())
    ZLogger.log(message: "number of favorite stations ==> \(favStationsCount ?? -1)", event: .info)
    self.updateFavBtn(with: 0xD91E18, andTitle: "Supprimer des favoris")
  }
  
  func removeFavoriteSuccess(code: Int?) {
    let favStationsCount = CoreStore.fetchCount(From<FavoriteStation>())
    ZLogger.log(message: "number of favorite stations ==> \(favStationsCount ?? -1)", event: .info)
    self.isFavStation = nil
    self.updateFavBtn(with: 0x3FC380, andTitle: "Ajouter aux favoris")
  }
  
  func failure(error: Error) {
    self.present(PopupManager.errorPopup(message: error.localizedDescription), animated: true)
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
