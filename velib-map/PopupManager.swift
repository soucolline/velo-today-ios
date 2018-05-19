//
//  PopupManager.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 24/04/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import UIKit

class PopupManager {
  static func showErrorPopup(message: String) -> UIAlertController {
    let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    
    return alert
  }
}
