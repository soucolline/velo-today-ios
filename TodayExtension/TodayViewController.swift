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
  @IBOutlet private var stationView: UIView!
  @IBOutlet private var noStationView: UIView!

  private let userDefaults = UserDefaults(suiteName: "group.com.zlatan.velib-map")!
  private let session = URLSession(configuration: URLSessionConfiguration.default)

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupInteraction()
    self.showLoadingView()
    self.downloadStationInfo()
  }

  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    self.downloadStationInfo()
    completionHandler(NCUpdateResult.newData)
  }

  private func setupInteraction() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openApp))
    self.view.addGestureRecognizer(tapGesture)
  }

  private func showLoadingView() {
    self.noStationView.isHidden = true
    self.bikesLabel.text = ""
    self.bikesLabel.textColor = UIColor.white
    self.standsLabel.text = ""
    self.standsLabel.textColor = UIColor.white
    self.nameLabel.text = "Chargment en cours"
  }

  private func downloadStationInfo() {
    guard let id = (self.userDefaults.array(forKey: "favoriteStationsCode") as? [String])?.first else {
      self.showNoStationView()
      return
    }
    
    let url = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&q=\(id)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    self.session.dataTask(with: url) { data, _,  _ in
      let resources = try! JSONDecoder().decode(FetchStationObjectResponseRoot.self, from: data!)

      DispatchQueue.main.async {
        self.showStationDetails(from: resources.records.first!.station)
      }
    }.resume()
  }

  private func showNoStationView() {
    self.noStationView.isHidden = false
    self.stationView.isHidden = true
  }

  private func showStationView() {
    self.noStationView.isHidden = true
    self.stationView.isHidden = false
  }

  private func showStationDetails(from station: Station) {
    let bikes = station.freeBikes
    let stands = station.freeDocks
    let name = station.name

    self.bikesLabel.text = "\(bikes) vélo\(bikes > 0 ? "s" : "")"
    self.standsLabel.text = "\(stands) place\(stands > 0 ? "s" : "")"
    self.nameLabel.text = name
  }

  @objc private func openApp() {
    self.extensionContext?.open(URL(string: "velib-map://")!)
  }
}
