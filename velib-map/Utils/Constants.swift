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
    static let green: UIColor = #colorLiteral(red: 0.2470588235, green: 0.7647058824, blue: 0.5019607843, alpha: 1)
    static let red: UIColor = #colorLiteral(red: 0.8509803922, green: 0.1176470588, blue: 0.09411764706, alpha: 1)
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
 
