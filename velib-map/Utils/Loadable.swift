//
//  Loadable.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

/**
 * Loadable protocol to show and dismiss waiter during API calls
 * Only implement this protocol to your ViewController, functions are automatically overriden
 */

protocol Loadable {
  var loaderMessage: String { get set }
  
  func onShowLoading()
  func onDismissLoading()
  func onServerError()
}

extension Loadable where Self: UIViewController {
  
  func onShowLoading() {
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.show(withStatus: loaderMessage)
  }
  
  func onDismissLoading() {
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.dismiss()
  }
  
  func onServerError() {
    self.present(PopupManager.showErrorPopup(message: "Une erreur interne est survenue"), animated: true)
  }
  
}
