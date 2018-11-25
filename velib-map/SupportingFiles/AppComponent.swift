//
//  AppComponent.swift
//  velib-map
//
//  Created by Zlatan on 25/11/2018.
//  Copyright © 2018 Thomas Guilleminot. All rights reserved.
//

import Swinject

class AppComponent {
  
  func getContainer() -> Container {
    let container = Container()
    
    container.register(MapService.self) { _ in
      return MapService()
    }
    
    container.register(CoreDataService.self) { _ in
      return CoreDataService()
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
        service: resolver.resolve(CoreDataService.self)!
      )
    }
    
    container.register(FavoritePresenter.self) { resolver in
      return FavoritePresenterImpl(
        service: resolver.resolve(MapService.self)!
      )
    }
    
    return container
  }
  
}
