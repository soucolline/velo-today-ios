//
//  StationRemoteDataSource.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Combine
import Moya

protocol StationRemoteDataSource {
  func fetchPins() async throws -> [StationResponse]
  func fetchAllStations(from ids: [String]) -> AnyPublisher<[StationResponse], APIError>
}

class StationRemoteDataSourceImpl: StationRemoteDataSource {
  private let apiWorker: APIWorker
  private let urlFactory: URLFactory
  private let provider: MoyaProvider<StationRouter>

  init(apiWorker: APIWorker, urlFactory: URLFactory, provider: MoyaProvider<StationRouter>) {
    self.apiWorker = apiWorker
    self.urlFactory = urlFactory
    self.provider = provider
  }

  func fetchPins() async throws -> [StationResponse] {
    let response = try await provider.getAsync(route: StationRouter.getAllStations, typeOf: FetchStationObjectResponseRoot.self)

    return response.records.map { $0.station }
  }

  func fetchAllStations(from ids: [String]) -> AnyPublisher<[StationResponse], APIError> {
    let publishers: [AnyPublisher<StationResponse, APIError>] = ids.map { id -> AnyPublisher<StationResponse, APIError> in
      let url = self.urlFactory.createFetchStation(from: id)

      return self.apiWorker.request(for: FetchStationObjectResponseRoot.self, at: url, method: .get, parameters: [:])
        .compactMap { response in
          response.records.first?.station
        }
        .eraseToAnyPublisher()
    }

    return Publishers.MergeMany(publishers)
      .collect()
      .eraseToAnyPublisher()
  }
}
