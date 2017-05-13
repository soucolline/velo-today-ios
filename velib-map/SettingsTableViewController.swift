//
//  SettingsTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.removeAllAccessoryType(tableview: self.tableView)
    let cell = self.tableView.cellForRow(at: indexPath)
    cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
    cell?.selectionStyle = .none
  }
  
  func removeAllAccessoryType(tableview: UITableView) {
    for row in 0..<tableview.numberOfRows(inSection: 0) {
      let indexPath = IndexPath(row: row, section: 0)
      let cell = tableview.cellForRow(at: indexPath)
      cell?.accessoryType = .none
    }
  }
}
