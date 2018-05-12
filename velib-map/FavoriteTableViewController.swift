//
//  FavoriteTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 18/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import CoreStore
import SwiftyJSON
import MBProgressHUD

class FavoriteTableViewController: UITableViewController, VelibEventBus {
  
  let interactor = VelibInteractor()
  var favStations = [FavoriteStation]()
  var fetchedStations = [Station]()
  var stationToSegue: Station?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favoris"
    self.tableView.tableFooterView = UIView(frame: .zero) // Hide empty cells
    
    VelibPresenter.register(observer: self, events: .fetchAllStationsSuccess, .failure)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.favStations = CoreStore.fetchAll(From<FavoriteStation>()) ?? []
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.fetchedStations.removeAll()
    self.fetchStations()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    MBProgressHUD.hide(for: self.view, animated: true)
    VelibPresenter.unregisterAll(observer: self)
  }
  
  func fetchStations() {
    guard !self.favStations.isEmpty else {
      self.tableView.reloadData()
      let noStationLoader = MBProgressHUD.showAdded(to: self.view, animated: true)
      noStationLoader.label.text = "Vous n'avez pas encore de favoris"
      noStationLoader.mode = .text
      noStationLoader.bounds = UIScreen.main.bounds
      return
    }
    
    let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
    loader.label.text = "Rafraichissement des données"
    self.interactor.fetchAllStations(favoriteStations: self.favStations)
  }
  
  func fetchAllStationsSuccess(stations: [Station]) {
    self.fetchedStations = stations
    self.tableView.reloadData()
    MBProgressHUD.hide(for: self.view, animated: true)
  }
  
  func failure(error: Error) {
    MBProgressHUD.hide(for: self.view, animated: true)
    self.present(PopupManager.showErrorPopup(message: error.localizedDescription), animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "favoriteToDetailSegue" {
      if let station = self.stationToSegue {
        let vc = segue.destination as? DetailsViewController
        vc?.currentStation = station
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.fetchedStations.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.stationToSegue = self.fetchedStations[indexPath.row]
    self.performSegue(withIdentifier: "favoriteToDetailSegue", sender: self)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as?   FavoriteTableViewCell
    cell?.feed(with: self.fetchedStations[indexPath.row])
    return cell ?? UITableViewCell()
  }
}
