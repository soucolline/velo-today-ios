//
//  SettingsPresenter.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 15/05/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol SettingsView: AnyObject {
  func onUpdateSegmentControl(for style: MapStyle)
}

protocol SettingsPresenter {
  func attach(_ view: SettingsView)
  func setup()
  func setMapStyle(style: MapStyle)
}

class SettingsPresenterImpl: SettingsPresenter {
  private let preferencesRepository: PreferencesRepository

  weak var view: SettingsView?

  init(preferencesRepository: PreferencesRepository) {
    self.preferencesRepository = preferencesRepository
  }

  func attach(_ view: SettingsView) {
    self.view = view
  }

  func setup() {
    self.view?.onUpdateSegmentControl(for: self.preferencesRepository.getMapStyle())
  }

  func setMapStyle(style: MapStyle) {
    self.preferencesRepository.setMapStyle(identifier: style.rawValue)
  }
}
