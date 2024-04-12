//
//  ListItemType.swift
//  Pokedex
//
//  Created by Luke Taylor on 13/03/2024.
//

import Foundation

struct ListItemType: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let image: String
    let resourceUrl: String
}
