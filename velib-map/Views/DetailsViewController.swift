//
//  DetailsViewController.swift
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

class DetailsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var stackViewBtns: UIStackView!
  @IBOutlet weak var bikesLabel: UILabel!
  @IBOutlet weak var electricBikesLabel: UILabel!
  @IBOutlet weak var standsLabel: UILabel!
  @IBOutlet weak var favBtn: UIButton!
  @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
  
  var currentStation: Station?
  
  var presenter: DetailsPresenter = ((UIApplication.shared.delegate as? AppDelegate)?.container.resolve(DetailsPresenter.self))!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.presenter.setView(view: self)
    self.presenter.setData(currentStation: self.currentStation)
    
    self.title = self.presenter.getCurrentStationTitle()
    self.mapView.delegate = self
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.mapHeightConstraint.constant = self.setMapHeight()
    
    if let station = self.presenter.getCurrentStation() {
      self.mapView.addAnnotation(station)
    }
    
    if let location = self.presenter.getCurrentStationLocation() {
      self.centerMap(on: location)
    }
    
    self.setupBtns()
    
    self.presenter.isFavoriteStation()
      ? self.updateFavBtn(with: K.Colors.red, andTitle: K.Strings.removeFavorite)
      : self.updateFavBtn(with: K.Colors.green, andTitle: K.Strings.addFavorite)
  }
  
  func setMapHeight() -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    return screenHeight == 568.0 ? screenHeight / 3 : screenHeight / 2
  }
  
  func centerMap(on location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius * 2.0,
      longitudinalMeters: regionRadius * 2.0
    )
    self.mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func setupBtns() {
    guard let station = self.presenter.getCurrentStation() else { return }
    
    _ = self.stackViewBtns.arrangedSubviews.map {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
    
    self.bikesLabel.text = "\(station.freeBikes) vélos disponibles"
    self.electricBikesLabel.text = "\(station.freeElectricBikes) vélos eléctriques disponibles"
    self.standsLabel.text = "\(station.freeDocks) stands disponibles"
  }
  
  func updateFavBtn(with color: UIColor, andTitle title: String) {
    self.favBtn.backgroundColor = color
    self.favBtn.setTitle(title, for: .normal)
  }
  
  @IBAction func toggleFavorite(_ sender: UIButton) {
    self.presenter.isFavoriteStation()
      ? self.presenter.removeFavorite()
      : self.presenter.addFavorite()
  }
  
}

extension DetailsViewController: DetailsViewDelegate {
  
  func onAddFavoriteSuccess(numberOfFavoriteStations: Int) {
    ZLogger.info(message: "number of favorite stations ==> \(numberOfFavoriteStations)")
    self.updateFavBtn(with: K.Colors.red, andTitle: K.Strings.removeFavorite)
  }
  
  func onRemoveFavoriteSuccess(numberOfFavoriteStations: Int) {
    ZLogger.info(message: "number of favorite stations ==> \(numberOfFavoriteStations)")
    self.updateFavBtn(with: K.Colors.green, andTitle: K.Strings.addFavorite)
  }
  
  func onAddFavoriteError() {
    self.present(
      PopupManager.showErrorPopup(message: "Impossible d'ajouter cette station au favoris, veuillez réessayer"),
      animated: true
    )
  }
  
  func onRemoveFavoriteError() {
    self.present(
      PopupManager.showErrorPopup(message: "Impossible de retirer cette station au favoris, veuillez réessayer"),
      animated: true
    )
  }
  
}

extension DetailsViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? Station else { return nil }
    
    let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: K.Identifiers.velibPin)
    pin.image = UIImage(named: "pin")
    
    return pin
  }
  
}
