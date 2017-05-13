//
//  SettingsTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .default
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.removeAllAccessoryType(tableview: self.tableView, inSection: 0)
    let cell = self.tableView.cellForRow(at: indexPath)
    cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
    self.changeMapStyle(style: cell?.reuseIdentifier)
  }
  
  func removeAllAccessoryType(tableview: UITableView, inSection section: Int) {
    for row in 0..<tableview.numberOfRows(inSection: section) {
      let indexPath = IndexPath(row: row, section: section)
      let cell = tableview.cellForRow(at: indexPath)
      cell?.accessoryType = .none
    }
  }
  
  func changeMapStyle(style: String?) {
    guard let style = style, style != ""
      else { return }
    
    self.defaults.set(style, forKey: "mapStyle")
  }
}
