//
//  AppComponent.swift
//  velib-map
//
//  Created by Zlatan on 25/11/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Swinject
import CoreStore
import ZLogger

class AppComponent {
  
  func getContainer() -> Container {
    let container = Container()
    
    container.register(MapService.self) { resolver in
      return MapService(
        with: resolver.resolve(APIWorker.self)!
      )
    }
    
    container.register(CoreDataService.self) { resolver in
      return CoreDataService(
        with: resolver.resolve(DataStack.self)!
      )
    }
    
    container.register(PreferencesRepository.self) { _ in
      return PreferencesRepository(with: UserDefaults.standard)
    }
    
    container.register(MapPresenter.self) { resolver in
      return MapPresenterImpl(
        service: resolver.resolve(MapService.self)!,
        repository: resolver.resolve(PreferencesRepository.self)!
      )
    }
    
    container.register(DetailsPresenter.self) { resolver in
      return DetailsPresenterImpl(
        with: resolver.resolve(CoreDataService.self)!,
        dataStack: resolver.resolve(DataStack.self)!
      )
    }
    
    container.register(FavoritePresenter.self) { resolver in
      return FavoritePresenterImpl(
        with: resolver.resolve(MapService.self)!,
        dataStack: resolver.resolve(DataStack.self)!
      )
    }
    
    container.register(DataStack.self) { _ in
      let dataStack = DataStack(
        xcodeModelName: "velibMap",
        migrationChain: []
      )
      
      do {
        try dataStack.addStorageAndWait()
      } catch {
        ZLogger.error(message: "Could not create Database")
      }
      
      return dataStack
    }
    
    container.register(NetworkSession.self) { _ in
      let session = URLSessionConfiguration.default
      session.timeoutIntervalForRequest = 10.0
      return URLSession(configuration: session)
    }
    
    container.register(APIWorker.self) { resolver in
      APIWorkerImpl(
        with: resolver.resolve(NetworkSession.self)!
      )
    }
    
    return container
  }
  
}
