//
//  File.swift
//  
//
//  Created by Thomas Guilleminot on 23/09/2022.
//

import Foundation
import Models

extension ApiClient {
  public static let live = Self(
    fetchStation: { id in
      let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=\(id)")!
      
      let (data, _) = try await URLSession.shared.data(from: url)
      let responseEnvelope = try JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data)
      
      guard let station = responseEnvelope.records.map({ $0.station }).first?.toStation() else {
        throw "No station"
      }
      
      return station
    },
    
    fetchAllStations: {
      let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&")!
      let (data, _) = try await URLSession.shared.data(from: url)
      let responseEnvelope = try JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data)
      let stations = responseEnvelope.records.map({ $0.station.toStation()})
      
      return stations
    }
  )
}
