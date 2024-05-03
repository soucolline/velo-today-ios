//
//  SettingsReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ComposableArchitecture
import UserDefaultsClient
import Models

@Reducer
public struct SettingsReducer {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage("mapStyle")) public var mapStyleUserDefaults: String = "normalStyle"
    
    public var mapStyle: MapStyle
    public var appVersion: String
    public var selectedPickerIndex: Int
    
    public init(
      mapStyle: MapStyle = MapStyle.normal,
      appVersion: String = "1.0.0",
      selectedPickerIndex: Int = 0
    ) {
      self.mapStyle = mapStyle
      self.appVersion = appVersion
      self.selectedPickerIndex = selectedPickerIndex
    }
  }
  
  public enum Action: Equatable, BindableAction {
    case onAppear
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.userDefaultsClient.getAppVersion) public var getAppVersion: () -> String
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        let mapStyle = MapStyle(rawValue: state.mapStyleUserDefaults) ?? .normal
        
        state.mapStyle = mapStyle
        state.selectedPickerIndex = mapStyle.pickerValue
        state.appVersion = self.getAppVersion()
        
        return .none
      
      case .binding(\.selectedPickerIndex):
        state.mapStyle = MapStyle.initFromInt(value: state.selectedPickerIndex)
        state.mapStyleUserDefaults = state.mapStyle.rawValue
        
        return .none

      case .binding:
        return .none
      }
    }
    ._printChanges()
  }
}
