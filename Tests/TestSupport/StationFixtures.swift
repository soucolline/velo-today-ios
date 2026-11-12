import ApiClient
import Models

package struct StubAPI: ApiClient {
  private let fetch: @Sendable () async throws -> [Station]

  package init(fetch: @escaping @Sendable () async throws -> [Station]) {
    self.fetch = fetch
  }

  package func fetchAllStations() async throws -> [Station] { try await fetch() }
}

package enum FetchError: Error { case offline }

package func makeStation(_ code: String) -> Station {
  Station(
    freeDocks: 12,
    code: code,
    name: "Station \(code)",
    totalDocks: 20,
    freeBikes: 8,
    freeMechanicalBikes: 5,
    freeElectricBikes: 3,
    geolocation: [48.85, 2.35]
  )
}
