//
//  FavoriteListView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import ApiClient
import UserDefaultsClient
import Models
import DetailsFeature

public struct FavoriteListView: View {
  let store: StoreOf<FavoriteReducer>

  public init(store: StoreOf<FavoriteReducer>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        ZStack {
          List {
            if viewStore.isFetchStationRequestInFlight {
              ForEach(0..<3) { _ in
                FavoriteEmptyCell()
              }
            } else {
              ForEach(viewStore.stations) { station in
                NavigationLink(
                  destination: DetailsView(
                    store: Store(
                      initialState: DetailsReducer.State(
                        station: station.toStationPin(),
                        title: station.name,
                        isFavoriteStation: true),
                      reducer: DetailsReducer()
                    )
                  )
                ) {
                  FavoriteCell(name: station.name, freeBikes: station.freeBikes, freeDocks: station.freeDocks)
                }
              }
            }
          }
          .navigationTitle("Favoris")
          
          if viewStore.shouldShowEmptyView {
            FavoriteEmptyView()
          }
          
          ErrorView(
            errorText: .constant(viewStore.errorText),
            isVisible: viewStore.binding(\.$shouldShowError)
          )
        }
      }
      .navigationViewStyle(.stack)
      .refreshable {
        viewStore.send(.fetchFavoriteStations)
      }
      .task {
        viewStore.send(.fetchFavoriteStations)
      }
    }
  }
}

#if DEBUG
struct FavoriteListView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteListView(
      store: Store(
        initialState: FavoriteReducer.State(
          stations: [
            Station(
              freeDocks: 12,
              code: "Code",
              name: "Name of the station",
              totalDocks: 12,
              freeBikes: 10,
              freeMechanicalBikes: 14,
              freeElectricBikes: 15,
              geolocation: [12, 13]
            ),
            Station(
              freeDocks: 1,
              code: "Code",
              name: "Name of the station but super long",
              totalDocks: 12,
              freeBikes: 10,
              freeMechanicalBikes: 14,
              freeElectricBikes: 15,
              geolocation: [12, 13]
            )
          ],
          isFetchStationRequestInFlight: false
        ),
        reducer: FavoriteReducer()
      )
    )
  }
}
#endif
