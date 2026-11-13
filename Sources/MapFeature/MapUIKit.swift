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
    let map = MapUIKit(
      center: store.center,
      isLoading: store.isLoading,
      stations: store.stations,
      style: store.style,
      onReload: { store.send(.reloadButtonTapped) },
      onStationTapped: { store.send(.stationPinTapped($0)) }
    )

    ZStack {
      if #available(iOS 26.0, *) {
        map.ignoresSafeArea()
      } else {
        map
      }
    }
    .onAppear { store.send(.onAppear) }
    .alert($store.scope(state: \.alert, action: \.alert))
    .sheet(item: $store.scope(state: \.details, action: \.details)) { detailsStore in
      let details = DetailsScreen(store: detailsStore)
      Group {
        if #available(iOS 27.1, *) {
          // The vertical system bar can inset the sheet even when it does not overlap it.
          details.ignoresSafeArea(.container, edges: .horizontal)
        } else {
          details
        }
      }
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
