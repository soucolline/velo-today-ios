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

class FavoriteTableViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!

  private let presenter: FavoritePresenter = Assembler.inject(FavoritePresenter.self)
  private let refreshControl = UIRefreshControl()
  
  var loaderMessage = "Chargement de vos stations préférées"

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favoris"
    
    self.presenter.attach(self)

    setupUI()
    self.presenter.fetchFavoriteStations()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    SVProgressHUD.dismiss()
  }

  private func setupUI() {
    self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)

    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.refreshControl = self.refreshControl
    self.tableView.tableFooterView = UIView(frame: .zero) // Hide empty cells
  }

  @objc private func reloadData() {
    presenter.fetchFavoriteStations()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.SegueIdentifiers.favoriteToDetailSegue {
      if let station = sender as? UIStation {
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
      self.refreshControl.endRefreshing()
    }
  }
  
  func onFetchStationsEmptyError() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      SVProgressHUD.setMinimumDismissTimeInterval(100.0)
      SVProgressHUD.showInfo(withStatus: "Vous n'avez pas encore de favoris")
    }
  }
  
  func onFetchStationsError() {
    DispatchQueue.main.async {
      self.refreshControl.endRefreshing()
      self.present(PopupManager.showErrorPopup(message: "Une erreur est survenue, veuillez réessayer"), animated: true)
    }
  }
  
}

extension FavoriteTableViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.presenter.getStationsCount()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectedStation = self.presenter.getStation(at: indexPath.row) {
      self.performSegue(withIdentifier: K.SegueIdentifiers.favoriteToDetailSegue, sender: selectedStation)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.favoriteCell, for: indexPath) as? FavoriteTableViewCell
    
    if let station = self.presenter.getStation(at: indexPath.row) {
      cell?.feed(with: station)
    }
    
    return cell ?? UITableViewCell()
  }
  
}
