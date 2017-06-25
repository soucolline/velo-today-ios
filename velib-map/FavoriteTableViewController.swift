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

class FavoriteTableViewController: UITableViewController {
  
  var favStations = [FavoriteStation]()
  var fetchedStations = [Station]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Liste des favoris"
    self.favStations = CoreStore.fetchAll(From<FavoriteStation>()) ?? []
    self.tableView.tableFooterView = UIView(frame: .zero) // Hide empty cells
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.fetchedStations.removeAll()
    self.fetchStations()
    self.tableView.reloadData()
  }
  
  func fetchStations() {
    let _ = self.favStations.map {
      let r = Just.get(Api.stationFrom($0.number).url)
      if r.ok {
        let responseJSON = JSON(r.json as Any)
        let station = Mapper.mapStations(newsJSON: responseJSON)
        self.fetchedStations.append(station)
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
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
    cell.feed(with: self.fetchedStations[indexPath.row])
    return cell
  }
}
