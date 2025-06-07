//
//  DetailsView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 07/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import MapKit
import UserDefaultsClient
import Models

public struct DetailsScreen: View {
  @Perception.Bindable var viewModel: DetailsScreenViewModel
  
  public init(viewModel: DetailsScreenViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        Map(coordinateRegion: $viewModel.stationLocation, interactionModes: [], annotationItems: [viewModel.station]) {
          MapMarker(coordinate: $0.coordinate, tint: .orange)
        }
        Button {
          viewModel.favoriteButtonTapped()
        } label: {
          Text(viewModel.isFavoriteStation ? "Suppprimer des favoris" : "Ajouter aux favoris")
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(viewModel.isFavoriteStation ? .red : .green)
        }
        
        VStack {
          Text("\(viewModel.station.freeMechanicalBikes) Velos disponibles")
            .stationStackStyle()
            .background(.orange)
            .cornerRadius(8)
          
          Text("\(viewModel.station.freeElectricBikes) Vélos éléctriques disponibles")
            .stationStackStyle()
            .background(.teal)
            .cornerRadius(8)
          
          Text("\(viewModel.station.freeDocks) stands disponibles")
            .stationStackStyle()
            .background(.pink)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
      }
      .navigationTitle(viewModel.title)
      .navigationBarTitleDisplayMode(.large)
      .onAppear {
        viewModel.onAppear()
      }
    }
  }
}

#Preview {
  NavigationView {
    DetailsScreen(
      viewModel: DetailsScreenViewModel()
    )
  }
}

struct StationStackStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(.white)
      .padding()
      .frame(height: 50)
      .frame(maxWidth: .infinity)
  }
}

extension View {
  func stationStackStyle() -> some View {
    modifier(StationStackStyle())
  }
}

extension MKCoordinateRegion: @retroactive Equatable {
  static public func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    (lhs.span.latitudeDelta == rhs.span.latitudeDelta) && (lhs.span.longitudeDelta == rhs.span.longitudeDelta) &&
    (lhs.center.latitude == rhs.center.latitude) && (lhs.center.longitude == rhs.center.longitude)
  }
}
