//
//  TabBarController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 07/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class TabBarController: UITabBarController, UITabBarControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    let tab1 = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MapViewController"))
    let tab1Item = UITabBarItem(title: "Stations disponibles", image: UIImage(named: "bike"), tag: 1)
    tab1.tabBarItem = tab1Item
    
    let tab2 = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "FavoriteTableViewController"))
    let tab2Item = UITabBarItem(title: "Favoris", image: UIImage(named: "star"), tag: 2)
    tab2.tabBarItem = tab2Item
    
    let tab3 = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "SettingsViewController"))
    let tab3Item = UITabBarItem(title: "Réglages", image: UIImage(named: "settings"), tag: 3)
    tab3.tabBarItem = tab3Item
    
    let tab4 = UIHostingController(rootView: SettingsViewTCA())
    let tab4Item = UITabBarItem(title: "Settings TCA", image: UIImage(named: "settings"), tag: 4)
    tab4.tabBarItem = tab4Item
    
    self.viewControllers = [tab1, tab2, tab3, tab4]
  }
}
