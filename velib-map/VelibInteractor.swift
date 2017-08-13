//
//  VelibInteractor.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol IVelibInteractor {
  func fetchPins()
}

class VelibInteractor: IVelibInteractor {
  
  let presenter = VelibPresenter()
  
  func fetchPins() {
    
  }
  
}
