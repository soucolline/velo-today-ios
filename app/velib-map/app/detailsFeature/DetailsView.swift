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

struct DetailsState: Equatable {
  var station: StationMarker = StationMarker(
    freeDocks: 1,
    code: "123",
    name: "Test name",
    totalDocks: 4,
    freeBikes: 5,
    freeMechanicalBikes: 6,
    freeElectricBikes: 7,
    geolocation: [20, 30]
  )
  
  var title = ""
  var isFavoriteStation = false
  
  @BindableState var stationLocation =  MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333),
    latitudinalMeters: 2000,
    longitudinalMeters: 2000
  )
}

enum DetailsAction: Equatable, BindableAction {
  case onAppear
  case binding(BindingAction<DetailsState>)
  case favoriteButtonTapped
}

struct DetailsEnvironment {
  var userDefaultsClient: UserDefaultsClient
}

let detailsReducer = Reducer<DetailsState, DetailsAction, DetailsEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    state.title = state.station.name
    state.stationLocation = MKCoordinateRegion(
      center: state.station.coordinate,
      latitudinalMeters: 500,
      longitudinalMeters: 500
    )
    
    state.isFavoriteStation = environment.userDefaultsClient.isFavoriteStation(code: state.station.code)
    
    return .none
    
  case .favoriteButtonTapped:
    if state.isFavoriteStation {
      state.isFavoriteStation = false
      return environment.userDefaultsClient
        .removeFavoriteStations(for: state.station.code)
        .fireAndForget()
      
    } else {
      state.isFavoriteStation = true
      return environment.userDefaultsClient
        .addFavoriteStation(for: state.station.code)
        .fireAndForget()
    }
    
  case .binding:
    return .none
  }
}
.binding()
.debug()

struct DetailsView: View {
  let store: Store<DetailsState, DetailsAction>
  
  var body: some View {
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
          reducer: detailsReducer,
          environment: DetailsEnvironment(
            userDefaultsClient: .noop
          )
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
