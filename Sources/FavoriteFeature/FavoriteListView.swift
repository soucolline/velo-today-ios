//
//  FavoriteListView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 12/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import Foundation
import SwiftUI
import ApiClient
import UserDefaultsClient
import Models
import DetailsFeature
import Perception

public struct FavoriteListScreen: View {
  @Perception.Bindable var viewModel: FavoriteScreenViewModel

  public init(viewModel: FavoriteScreenViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    WithPerceptionTracking {
      NavigationView {
        ZStack {
          List {
            if viewModel.isFetchStationRequestInFlight {
              ForEach(0..<3) { _ in
                FavoriteEmptyCell()
              }
            } else {
              ForEach(viewModel.favoriteStations) { station in
                NavigationLink {
                  DetailsScreen(
                    viewModel: DetailsScreenViewModel(
                      station: station.toStationPin(),
                      isFavoriteStation: true
                    )
                  )
                } label: {
                  FavoriteCell(name: station.name, freeBikes: station.freeBikes, freeDocks: station.freeDocks)
                }
              }
            }
          }
          .navigationTitle("Favoris")
          
          if viewModel.shouldShowEmptyView {
            FavoriteEmptyView()
          }
          
          ErrorView(
            errorText: $viewModel.errorText,
            isVisible: $viewModel.shouldShowError
          )
        }
        .onAppear {
          viewModel.onAppear()
        }
      }
      .navigationViewStyle(.stack)
      .refreshable {
        await viewModel.fetchFavoriteStations()
      }
    }
  }
}

#Preview {
  FavoriteListScreen(
    viewModel: FavoriteScreenViewModel(
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
    )
  )
}
