//
//  MoyaProviderExtensions.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 30/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Moya

extension MoyaProviderType {
  func getAsync<T: Decodable>(route: Target, typeOf: T.Type) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
      _ = self.request(route, callbackQueue: nil, progress: nil) { result in
        switch result {
          case let .success(moyaResponse):
              do {
                let object = try moyaResponse.map(T.self, failsOnEmptyData: true)
                continuation.resume(returning: object)
              } catch {
                continuation.resume(throwing: APIError.couldNotDecodeJSON)
              }
          case let .failure(error):
            continuation.resume(throwing: error)
        }
      }
    }
  }
}
