import ComposableArchitecture
import DetailsFeature
import Models
import SwiftUI

public struct MapScreen: View {
  @Bindable var store: StoreOf<MapFeature>

  public init(store: StoreOf<MapFeature>) {
    self.store = store
  }

  public var body: some View {
    MapUIKit(
      center: store.center,
      isLoading: store.isLoading,
      stations: store.stations,
      style: store.style,
      onReload: { store.send(.reloadButtonTapped) },
      onStationTapped: { store.send(.stationPinTapped($0)) }
    )
    .onAppear { store.send(.onAppear) }
    .alert($store.scope(state: \.alert, action: \.alert))
    .sheet(item: $store.scope(state: \.details, action: \.details)) { detailsStore in
      DetailsScreen(store: detailsStore)
        .presentationDetents([.medium])
    }
  }
}

private struct MapUIKit: UIViewControllerRepresentable {
  let center: MapLocation
  let isLoading: Bool
  let stations: [Station]
  let style: Models.MapStyle
  let onReload: () -> Void
  let onStationTapped: (Station) -> Void

  func makeUIViewController(context: Context) -> UINavigationController {
    UINavigationController(rootViewController: MapViewController())
  }

  func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
    guard let controller = navigationController.viewControllers.first as? MapViewController else { return }
    controller.onReload = onReload
    controller.onStationTapped = onStationTapped
    controller.render(center: center, isLoading: isLoading, stations: stations, style: style)
  }
}
