//
//  SettingsTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import Swinject

class SettingsViewController: UIViewController {
  @IBOutlet private var segmentedControl: UISegmentedControl!

  private let presenter = Assembler.inject(SettingsPresenter.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Réglages"

    self.presenter.attach(self)
    self.presenter.setup()
  }
  
  private func changeMapStyle(style: MapStyle) {
    self.presenter.setMapStyle(style: style)
  }

  @IBAction private func didChangeMapStyle(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
      case 0: self.changeMapStyle(style: .normal)
      case 1: self.changeMapStyle(style: .hybrid)
      case 2: self.changeMapStyle(style: .satellite)
      default: ()
    }
  }
}

extension SettingsViewController: SettingsView {
  func onUpdateSegmentControl(for style: MapStyle) {
    switch style {
      case .normal: self.segmentedControl.selectedSegmentIndex = 0
      case .hybrid: self.segmentedControl.selectedSegmentIndex = 1
      case .satellite: self.segmentedControl.selectedSegmentIndex = 2
    }
  }
}
