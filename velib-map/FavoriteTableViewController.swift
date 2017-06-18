//
//  FavoriteTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 18/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import CoreStore

class FavoriteTableViewController: UITableViewController {
  
  var favStations = [FavoriteStation]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Liste des favoris"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.favStations = CoreStore.fetchAll(From<FavoriteStation>()) ?? []
    self.tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.favStations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
    cell.textLabel?.text = self.favStations[indexPath.row].name
    return cell
  }
}
