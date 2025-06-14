//
//  SettingsScreenViewModel.swift
//  velo-today-ios
//
//  Created by Thomas Guilleminot on 07/06/2025.
//

import Dependencies
import Perception
import Sharing
import UserDefaultsClient
import Models
import Foundation

@Perceptible
public class SettingsScreenViewModel {
  @PerceptionIgnored
  @Shared(.appStorage("mapStyle")) public var mapStyleUserDefaults: String = "normalStyle"
  @PerceptionIgnored
  @Dependency(\.userDefaultsRepository) public var userDefaultsRepository
  
  public var mapStyle: MapStyle
  public var appVersion: String

  public var selectedPickerIndex: Int {
    didSet {
      mapStyle = MapStyle.initFromInt(value: self.selectedPickerIndex)
      $mapStyleUserDefaults.withLock { $0 = mapStyle.rawValue }
    }
  }
  
  public init(
    mapStyle: MapStyle = MapStyle.normal,
    appVersion: String = "1.0.0",
    selectedPickerIndex: Int = 0
  ) {
    self.mapStyle = mapStyle
    self.appVersion = appVersion
    self.selectedPickerIndex = selectedPickerIndex
    
  }
  
  public func onAppear() {
    let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
    
    self.mapStyle = mapStyle
    selectedPickerIndex = mapStyle.pickerValue
    appVersion = userDefaultsRepository.getAppVersion()
  }
}
