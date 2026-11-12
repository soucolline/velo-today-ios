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
import Models

public struct DetailsScreen: View {
  let store: StoreOf<DetailsFeature>
  
  public init(store: StoreOf<DetailsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(
        center: store.station.coordinate,
        latitudinalMeters: 200,
        longitudinalMeters: 200
      ))), interactionModes: []) {
        Marker(store.station.name, coordinate: store.station.coordinate)
          .tint(.orange)
      }
      Button {
        store.send(.favoriteButtonTapped)
      } label: {
        Text(store.isFavoriteStation ? "Supprimer des favoris" : "Ajouter aux favoris")
          .foregroundColor(.white)
          .frame(height: 40)
          .frame(maxWidth: .infinity)
          .background(store.isFavoriteStation ? .red : .green)
      }
      
      VStack {
        Text("\(store.station.freeMechanicalBikes) Velos disponibles")
          .stationStackStyle()
          .background(.orange)
          .cornerRadius(8)
        
        Text("\(store.station.freeElectricBikes) Vélos éléctriques disponibles")
          .stationStackStyle()
          .background(.teal)
          .cornerRadius(8)
        
        Text("\(store.station.freeDocks) stands disponibles")
          .stationStackStyle()
          .background(.pink)
          .cornerRadius(8)
      }
      .frame(maxWidth: .infinity)
      .padding(20)
    }
    .navigationTitle(store.station.name)
    .navigationBarTitleDisplayMode(.large)
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
