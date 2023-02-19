//
//  SettingsReducer.swift
//  
//
//  Created by Thomas Guilleminot on 04/12/2022.
//

import ComposableArchitecture
import UserDefaultsClient
import Models

public struct SettingsReducer: ReducerProtocol {
  public struct State: Equatable {
    public var mapStyle: MapStyle
    public var appVersion: String
    @BindingState public var selectedPickerIndex: Int
    
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
  
  @Dependency(\.userDefaultsClient) public var userDefaultsClient
  @Dependency(\.userDefaultsClient.getAppVersion) public var getAppVersion: () -> String
  
  public init() {}
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        let mapStyleUserDefaults = self.userDefaultsClient.stringForKey("mapStyle") ?? "normal"
        
        let mapStyle = MapStyle(rawValue: mapStyleUserDefaults) ?? .normal
        
        state.mapStyle = mapStyle
        state.selectedPickerIndex = mapStyle.pickerValue
        state.appVersion = self.getAppVersion()
        
        return .none
      
      case .binding(\.$selectedPickerIndex):
        state.mapStyle = MapStyle.initFromInt(value: state.selectedPickerIndex)
        
        return self.userDefaultsClient
          .setString(state.mapStyle.rawValue, "mapStyle")
          .fireAndForget()
        
      case .binding:
        return .none
      }
    }
    ._printChanges()
  }
}
