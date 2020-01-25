//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Thomas Guilleminot on 25/01/2020.
//  Copyright © 2020 Thomas Guilleminot. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

  @IBOutlet private var bikesLabel: UILabel!
  @IBOutlet private var standsLabel: UILabel!
  @IBOutlet private var nameLabel: UILabel!

  private let userDefaults = UserDefaults(suiteName: "group.com.zlatan.velib-map")!
  private let session = URLSession(configuration: URLSessionConfiguration.default)

  override func viewDidLoad() {
    super.viewDidLoad()

    self.downloadStationInfo()
  }

  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    completionHandler(NCUpdateResult.newData)
  }

  private func downloadStationInfo() {
    let id = (self.userDefaults.array(forKey: "favoriteStationsCode") as! [String]).first!
    let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&rows=1000&q=station_code%3D+\(id)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    self.session.dataTask(with: url) { data, _,  _ in
      let resources = try! JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data!)

      DispatchQueue.main.async {
        self.showStationDetails(from: resources.records.first!.station)
      }
    }.resume()
  }

  private func showStationDetails(from station: Station) {
    let bikes = station.freeBikes + station.freeElectricBikes
    let stands = station.freeDocks
    let name = station.name

    self.bikesLabel.text = "\(bikes) vélo\(bikes > 0 ? "s" : "")"
    self.standsLabel.text = "\(stands) place\(stands > 0 ? "s" : "")"
    self.nameLabel.text = name
  }

}

struct FetchStationObjectResponseRoot: Decodable {
  let records: [FetchStationObjectResponse]
}

struct FetchStationObjectResponse: Codable {

  let station: Station

  enum CodingKeys: String, CodingKey {
    case station = "fields"
  }

}
struct Station: Codable {
  let freeDocks: Int
  let code: String
  let name: String
  let totalDocks: Int
  let freeBikes: Int
  let freeElectricBikes: Int
  let geo: [Double]

  enum CodingKeys: String, CodingKey {
    case freeDocks = "nbfreeedock"
    case code = "station_code"
    case name = "station_name"
    case totalDocks = "nbedock"
    case freeBikes = "nbbike"
    case freeElectricBikes = "nbebike"
    case geo
  }
}
