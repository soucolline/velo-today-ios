//
//  FavoriteStation+CoreDataClass.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 25/05/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import CoreData

@objc(FavoriteStation)
public class FavoriteStation: NSManagedObject {
  
  @NSManaged public var name: String?
  @NSManaged public var address: String?
  @NSManaged public var availableBikeStands: Int16
  @NSManaged public var availableBikes: Int16
  @NSManaged public var number: Int32
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStation> {
    return NSFetchRequest<FavoriteStation>(entityName: "FavoriteStation")
  }
  
}
