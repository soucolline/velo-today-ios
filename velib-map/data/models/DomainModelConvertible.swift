//
//  DomainModelConvertible.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 29/12/2021.
//  Copyright © 2021 Thomas Guilleminot. All rights reserved.
//

import Foundation

protocol DomainModelConvertible {
    associatedtype DomainType
    func toDomain() throws -> DomainType
}
