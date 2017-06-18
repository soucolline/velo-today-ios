//
//  FavoriteTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 18/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Liste des favoris"
    self.navigationController?.navigationBar.barTintColor = UIColor.orange
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
}
