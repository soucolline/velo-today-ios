//
//  APIWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Bugsnag

protocol TaskExecutable: Codable {}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol APIWorker {
  func request<T: TaskExecutable>(for type: T.Type, at url: URL, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<T, APIError>) -> Void)
}

class APIWorkerImpl: APIWorker {
  
  private let session: NetworkSession
  
  init(with session: NetworkSession) {
    self.session = session
  }
  
  func request<T: TaskExecutable>(for type: T.Type, at url: URL, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<T, APIError>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    
    self.session.loadData(from: url) { data, error in
      guard error == nil else {
        Bugsnag.notify(NSException(name: NSExceptionName(rawValue: "API Error"), reason: error?.localizedDescription))
        completion(.failure(.customError(error?.localizedDescription ?? "Unknown error")))
        return
      }
      
      guard let jsonData = data else {
        Bugsnag.notify(NSException(name: NSExceptionName(rawValue: "API Error"), reason: "No data"))
        completion(.failure(.noData))
        return
      }
      
      do {
        let resources = try JSONDecoder().decode(type, from: jsonData)
        completion(.success(resources))
      } catch {
        Bugsnag.notify(NSException(name: NSExceptionName(rawValue: "API Error"), reason: "Could not decode JSON"))
        completion(.failure(.couldNotDecodeJSON))
      }
    }
  }
  
}
