//
//  VelibPresenter.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import MagicSwiftBus

@objc protocol VelibEventBus {
  @objc optional func fetchPinsSuccess(stations: [Station])
  @objc optional func failure(error: Error)
}

class VelibPresenter: Bus {
  
  public enum EventBus: String, EventBusType {
    case fetchPinsSuccess
    case failure
    
    public var notification: Selector {
      switch self {
      case .fetchPinsSuccess:
        return #selector(VelibEventBus.fetchPinsSuccess(stations:))
      case .failure:
        return #selector(VelibEventBus.failure(error:))
      }
    }
  }
  
  public func fetchPinsSuccess(stations: Station) {
    VelibPresenter.postOnMainThread(event: .fetchPinsSuccess, object: stations)
  }
  
  public func failure(error: Error) {
    VelibPresenter.postOnMainThread(event: .failure, object: error as AnyObject)
  }
  
}

