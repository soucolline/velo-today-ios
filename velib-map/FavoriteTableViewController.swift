//
//  FavoriteTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 18/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import CoreStore
import Just
import SwiftyJSON
import MBProgressHUD

class FavoriteTableViewController: UITableViewController {
  
  var favStations = [FavoriteStation]()
  var fetchedStations = [Station]()
  var stationToSegue: Station?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favoris"
    self.tableView.tableFooterView = UIView(frame: .zero) // Hide empty cells
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.favStations = CoreStore.fetchAll(From<FavoriteStation>()) ?? []
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.fetchedStations.removeAll()
    self.fetchStations()
    self.tableView.reloadData()
  }
  
  func fetchStations() {
    let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
    loader.label.text = "Rafraichissement des données"
    
    let _ = self.favStations.map {
      let r = Just.get(Api.stationFrom($0.number).url)
      if r.ok {
        let responseJSON = JSON(r.json as Any)
        let station = Mapper.mapStations(newsJSON: responseJSON)
        self.fetchedStations.append(station)
      } else {
        self.present(PopupManager.errorPopup(message: "Impossible de recuperer les informations des stations"), animated: true)
      }
    }
    MBProgressHUD.hide(for: self.view, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "favoriteToDetailSegue" {
      if let station = self.stationToSegue {
        let vc = segue.destination as? DetailViewController
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
    cell.feed(with: self.fetchedStations[indexPath.row])
    return cell
  }
}
