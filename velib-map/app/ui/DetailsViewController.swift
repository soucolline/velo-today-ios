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
import ZLogger
import Swinject

class DetailsViewController: UIViewController {
  
  @IBOutlet private var mapView: MKMapView!
  @IBOutlet private var stackViewBtns: UIStackView!
  @IBOutlet private var bikesLabel: UILabel!
  @IBOutlet private var electricBikesLabel: UILabel!
  @IBOutlet private var standsLabel: UILabel!
  @IBOutlet private var favBtn: UIButton!
  
  var currentStation: UIStation?

  private let presenter: DetailsPresenter = Assembler.inject(DetailsPresenter.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.presenter.attach(self)
    self.presenter.setData(currentStation: self.currentStation)
    
    self.title = self.presenter.getCurrentStationTitle()
    self.mapView.delegate = self
    
    self.setupUI()
  }
  
  private func setupUI() {
    if let station = self.presenter.getCurrentStation() {
      self.mapView.addAnnotation(station)
    }
    
    if let location = self.presenter.getCurrentStationLocation() {
      self.centerMap(on: location)
    }
    
    self.setupBtns()
    
    self.presenter.getIsFavoriteStation()
      ? self.updateFavBtn(with: K.Colors.red, andTitle: K.Strings.removeFavorite)
      : self.updateFavBtn(with: K.Colors.green, andTitle: K.Strings.addFavorite)
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
    
    self.stackViewBtns.arrangedSubviews.forEach {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
    
    self.bikesLabel.text = "\(station.freeMechanicalBikes) vélos disponibles"
    self.electricBikesLabel.text = "\(station.freeElectricBikes) vélos eléctriques disponibles"
    self.standsLabel.text = "\(station.freeDocks) stands disponibles"
  }
  
  func updateFavBtn(with color: UIColor, andTitle title: String) {
    self.favBtn.backgroundColor = color
    self.favBtn.setTitle(title, for: .normal)
  }
  
  @IBAction private func toggleFavorite(_ sender: UIButton) {
    self.presenter.getIsFavoriteStation()
      ? self.presenter.removeFavorite()
      : self.presenter.addFavorite()
  }
  
}

extension DetailsViewController: DetailsView {
  
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
    guard let annotation = annotation as? UIStation else { return nil }
    
    let pin = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: K.Identifiers.velibPin)
    pin.markerTintColor = K.Colors.orange
    
    return pin
  }
  
}
