import ComposableArchitecture
import DetailsFeature
import SwiftUI

public struct FavoriteListScreen: View {
  @Bindable var store: StoreOf<FavoriteFeature>

  public init(store: StoreOf<FavoriteFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        if store.isRefreshing {
          ForEach(0..<3) { _ in
            FavoriteEmptyCell()
          }
        } else {
          ForEach(store.favoriteStations) { station in
            Button {
              store.send(.stationTapped(station))
            } label: {
              HStack {
                FavoriteCell(name: station.name, freeBikes: station.freeBikes, freeDocks: station.freeDocks)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                  .font(.caption.weight(.semibold))
                  .foregroundStyle(.tertiary)
                  .accessibilityHidden(true)
              }
              .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
          }
        }
      }
      .navigationTitle("Favoris")
      .refreshable { await store.send(.pulledToRefresh).finish() }
      .overlay {
        if store.showsEmptyView {
          FavoriteEmptyView()
            .allowsHitTesting(false)
        }

        ErrorView(
          errorText: "Impossible de charger les données de certaines stations",
          isVisible: store.showsError
        )
        .allowsHitTesting(false)
      }
      .onDisappear { store.send(.listDisappeared) }
    } destination: { detailsStore in
      DetailsScreen(store: detailsStore)
    }
  }
}
