//
//  FavoriteTableViewController.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 18/06/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import UIKit
import SVProgressHUD
import Swinject

class FavoriteTableViewController: UITableViewController {
  
  var loaderMessage = "Chargement de vos stations préférées"

  private let presenter: FavoritePresenter = Assembler.inject(FavoritePresenter.self)

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favoris"
    
    self.presenter.attach(self)
    
    self.tableView.tableFooterView = UIView(frame: .zero) // Hide empty cells
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.presenter.fetchFavoriteStations()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    SVProgressHUD.dismiss()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.SegueIdentifiers.favoriteToDetailSegue {
      if let station = sender as? Station {
        let vc = segue.destination as? DetailsViewController
        vc?.currentStation = station
      }
    }
  }
 
}

extension FavoriteTableViewController: FavoriteView {
  
  func onFetchStationsSuccess() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func onFetchStationsEmptyError() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      SVProgressHUD.setMinimumDismissTimeInterval(100.0)
      SVProgressHUD.showInfo(withStatus: "Vous n'avez pas encore de favoris")
    }
  }
  
  func onFetchStationsError() {
    DispatchQueue.main.async {
      self.present(PopupManager.showErrorPopup(message: "Une erreur est survenue, veuillez réessayer"), animated: true)
    }
  }
  
}

extension FavoriteTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.presenter.getStationsCount()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectedStation = self.presenter.getStation(at: indexPath.row) {
      self.performSegue(withIdentifier: K.SegueIdentifiers.favoriteToDetailSegue, sender: selectedStation)
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.favoriteCell, for: indexPath) as? FavoriteTableViewCell
    
    if let station = self.presenter.getStation(at: indexPath.row) {
      cell?.feed(with: station)
    }
    
    return cell ?? UITableViewCell()
  }
  
}
