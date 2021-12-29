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
  private let getMapStyle: GetMapStyleUseCase
  private let setMapStyle: SetMapStyleUseCase

  private weak var view: SettingsView?

  init(
    getMapStyle: GetMapStyleUseCase,
    setMapStyle: SetMapStyleUseCase
  ) {
    self.getMapStyle = getMapStyle
    self.setMapStyle = setMapStyle
  }

  func attach(_ view: SettingsView) {
    self.view = view
  }

  func setup() {
    self.view?.onUpdateSegmentControl(for: self.getMapStyle.invoke())
  }

  func setMapStyle(style: MapStyle) {
    setMapStyle.invoke(identifier: style.rawValue)
  }
}
