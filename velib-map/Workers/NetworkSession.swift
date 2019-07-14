//
//  NetworkSession.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol NetworkSession {
  func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
  func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
    let task = dataTask(with: url) { (data, _, error) in
      completionHandler(data, error)
    }
    
    task.resume()
  }
}
