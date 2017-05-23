//
//  DetailViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 23/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var currentStation: Station?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let station = self.currentStation {
      print("station number = \(station.number ?? -1)")
    }
  }
  
}
