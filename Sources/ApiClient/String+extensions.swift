//
//  File.swift
//  
//
//  Created by Thomas Guilleminot on 23/09/2022.
//

import Foundation

extension String: Error {}

extension String: LocalizedError {
  public var errorDescription: String? { self }
}
