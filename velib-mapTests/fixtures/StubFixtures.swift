//
//  StubFixtures.swift
//  velib-mapTests
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

@testable import velib_map

class StubFixtures {
  class FetchStationObjectResponseRootUtils {
    static func create() -> FetchStationObjectResponseRoot {
      FetchStationObjectResponseRoot(
        records: [
          FetchStationObjectResponse(
            station: Station(
              freeDocks: 32,
              code: "17026",
              name: "Jouffroy d'Abbans - Wagram",
              totalDocks: 0,
              freeBikes: 5,
              freeMechanicalBikes: 6,
              freeElectricBikes: 7,
              geo: [48.881973298351625, 2.301132157444954]
            )
          )
        ]
      )
    }

    static func createSecond() -> FetchStationObjectResponseRoot {
      FetchStationObjectResponseRoot(
        records: [
          FetchStationObjectResponse(
            station: Station(
              freeDocks: 11,
              code: "12346",
              name: "Asnière Gare",
              totalDocks: 2,
              freeBikes: 3,
              freeMechanicalBikes: 9,
              freeElectricBikes: 2,
              geo: [22.2369368721, 22.2367232]
            )
          )
        ]
      )
    }
  }

  class StationsUtils {
    static func create() -> [Station] {
      [
        Station(freeDocks: 1, code: "sdhjsk", name: "test 1", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2]),
        Station(freeDocks: 1, code: "sdsjhdsk", name: "test 2", totalDocks: 2, freeBikes: 3, freeMechanicalBikes: 4, freeElectricBikes: 4, geo: [1, 2])
      ]
    }
  }
}
