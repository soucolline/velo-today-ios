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
  case couldNotDecodeJSON
  case noData
  case unknown
  case urlNotValid
  case customError(String)
  
  var localizedDescription: String {
    switch self {
    case .notFound:
      return "Endpoint not found"
    case .internalServerError:
      return "Internal server error"
    case .noData:
      return "No data found"
    case .couldNotDecodeJSON:
      return "Could not parse JSON"
    case .unknown:
      return "An unknown error happened"
      case .urlNotValid:
        return "Could not find the URL"
    case .customError(let message):
      return message
    }
  }
}

extension APIError: Equatable {}
