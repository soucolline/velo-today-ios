//
//  APIWorker.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 14/07/2019.
//  Copyright © 2019 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Bugsnag
import Combine

protocol TaskExecutable: Codable {}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol APIWorker {
  func request<T: TaskExecutable>(for type: T.Type, at url: URL, method: HTTPMethod, parameters: [String: Any]) -> AnyPublisher<T, APIError>
}

class APIWorkerImpl: APIWorker {
  
  private let session: NetworkSession
  
  init(with session: NetworkSession) {
    self.session = session
  }

  func request<T: TaskExecutable>(for type: T.Type, at url: URL, method: HTTPMethod, parameters: [String: Any]) -> AnyPublisher<T, APIError> {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

    return self.session.loadData(from: url)
      .tryMap { output in
        guard let response = output.response as? HTTPURLResponse else {
          throw APIError.urlNotValid
        }

        switch response.statusCode {
          case 200:
            return output.data
          default:
            throw APIError.noData
        }
      }
      .decode(type: type, decoder: JSONDecoder())
      .mapError { error in
        switch error {
          case is APIError:
            return (error as? APIError) ?? .customError(error.localizedDescription)
          case is Swift.DecodingError:
            return .couldNotDecodeJSON
          default:
            return .customError(error.localizedDescription)
        }
      }
      .eraseToAnyPublisher()
  }
  
}
