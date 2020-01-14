//
//  AppComponent.swift
//  velib-map
//
//  Created by Zlatan on 25/11/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Swinject
import ZLogger

// swiftlint:disable function_body_length
class AppComponent {
  
  func getContainer() -> Container {
    let container = Container()
    
    container.register(MapService.self) { resolver in
      MapService(
        with: resolver.resolve(APIWorker.self)!
      )
    }
    
    container.register(PreferencesRepository.self) { resolver in
      PreferencesRepository(
        with: resolver.resolve(UserDefaults.self)!
      )
    }

    container.register(FavoriteRepository.self) { resolver in
      FavoriteRepository(
        with: resolver.resolve(UserDefaults.self)!
      )
    }

    container.register(UserDefaults.self) { _ in
      UserDefaults.standard
    }
    
    container.register(MapPresenter.self) { resolver in
      MapPresenterImpl(
        service: resolver.resolve(MapService.self)!,
        repository: resolver.resolve(PreferencesRepository.self)!
      )
    }
    
    container.register(DetailsPresenter.self) { resolver in
      DetailsPresenterImpl(
        with: resolver.resolve(FavoriteRepository.self)!
      )
    }
    
    container.register(FavoritePresenter.self) { resolver in
      FavoritePresenterImpl(
        with: resolver.resolve(MapService.self)!,
        favoriteRepository: resolver.resolve(FavoriteRepository.self)!
      )
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
