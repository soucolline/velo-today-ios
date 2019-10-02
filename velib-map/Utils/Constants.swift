//
//  Constants.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation
import UIKit

struct K {
  
  struct Api {
    static let baseUrl = "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000"
    static let stationQuery = "&q=station_code%3D+"
  }
  
  struct Colors {
    static let green = UIColor.systemGreen
    static let red = UIColor.systemRed
  }
  
  struct Strings {
    static let addFavorite = "Ajouter aux favoris"
    static let removeFavorite = "Supprimer des favoris"
  }
  
  struct SegueIdentifiers {
    static let detailSegue = "detailStationSegue"
    static let favoriteToDetailSegue = "favoriteToDetailSegue"
  }
  
  struct Preferences {
    static let mapStyle = "mapStyle"
  }
  
  struct Identifiers {
    static let velibPin = "velibPin"
    static let favoriteCell = "favoriteCell"
  }
  
}
 
