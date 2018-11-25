//
//  FavoriteTableViewCell.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 25/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelsStack: UIStackView!
  @IBOutlet weak var bikesLabel: UILabel!
  @IBOutlet weak var standsLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    _ = self.labelsStack.subviews.map {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5.0
    }
  }
  
  func feed(with station: Station) {
    let bikes = station.numbikesavailable
    let stands = station.numdocksavailable
    let name = station.name
    
    self.bikesLabel.text = "\(bikes) vélo\(bikes > 0 ? "s" : "")"
    self.standsLabel.text = "\(stands) place\(stands > 0 ? "s" : "")"
    self.nameLabel.text = name
  }
  
}