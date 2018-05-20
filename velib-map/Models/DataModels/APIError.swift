//
//  APIError.swift
//  velib-map
//
//  Created by Zlatan on 12/05/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Foundation

enum APIError: Error {
  case notFound
  case internalServerError
  case couldNotDecodeData
  case unknown
}
