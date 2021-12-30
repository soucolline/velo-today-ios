//
//  StationRouter.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 30/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation
import Moya

// swiftlint:disable force_unwrapping
enum StationRouter: TargetType {
  case getAllStations
  case getSpecificStation(id: String)

  var baseURL: URL {
    switch self {
      case .getAllStations: return URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000")!
      case let .getSpecificStation(id): return URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=\(id)")!
    }
  }

  var path: String {
    switch self {
      case .getAllStations: return ""
      case let .getSpecificStation(id): return ""
    }
  }

  var method: Moya.Method {
    switch self {
      case .getAllStations: return .get
      case .getSpecificStation: return .get
    }
  }

  var task: Task {
    switch self {
      case .getAllStations: return .requestPlain
      case .getSpecificStation: return .requestPlain
    }
  }

  var sampleData: Data { Data() }

  var headers: [String: String]? { nil }
}
