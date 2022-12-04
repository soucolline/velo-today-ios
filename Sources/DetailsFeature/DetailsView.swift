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

public struct DetailsView: View {
  let store: StoreOf<DetailsReducer>
  
  public init(store: StoreOf<DetailsReducer>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        Map(coordinateRegion: viewStore.binding(\.$stationLocation), interactionModes: [], annotationItems: [viewStore.station]) {
          MapMarker(coordinate: $0.coordinate, tint: .orange)
        }
        Button {
          viewStore.send(.favoriteButtonTapped)
        } label: {
          Text(viewStore.isFavoriteStation ? "Suppprimer des favoris" : "Ajouter aux favoris")
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(viewStore.isFavoriteStation ? .red : .green)
        }
        
        VStack {
          Text("\(viewStore.station.freeMechanicalBikes) Velos disponibles")
            .stationStackStyle()
            .background(.orange)
            .cornerRadius(8)
          
          Text("\(viewStore.station.freeElectricBikes) Vélos éléctriques disponibles")
            .stationStackStyle()
            .background(.teal)
            .cornerRadius(8)
          
          Text("\(viewStore.station.freeDocks) stands disponibles")
            .stationStackStyle()
            .background(.pink)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
      }
      .navigationTitle(viewStore.title)
      .navigationBarTitleDisplayMode(.large)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

#if DEBUG
struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailsView(
        store: Store(
          initialState: .init(),
          reducer: DetailsReducer()
        )
      )
    }
  }
}
#endif

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
  @warn_unqualified_access
  func stationStackStyle() -> some View {
    modifier(StationStackStyle())
  }
}

extension MKCoordinateRegion: Equatable {
  static public func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    (lhs.span.latitudeDelta == rhs.span.latitudeDelta) && (lhs.span.longitudeDelta == rhs.span.longitudeDelta) &&
    (lhs.center.latitude == rhs.center.latitude) && (lhs.center.longitude == rhs.center.longitude)
  }
}
