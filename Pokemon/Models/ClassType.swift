//
//  ClassType.swift
//  Pokemon
//
//  Created by Luke Taylor on 07/03/2024.
//

import Foundation
import PokemonAPI
import SwiftUI

enum PokemonClassType: String, Decodable, Identifiable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case shadow
    
    var id: String { return rawValue }
    
    var name: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .normal: Color.types.normal
        case .fighting: Color.types.fighting
        case .flying: Color.types.flying
        case .poison: Color.types.poison
        case .ground: Color.types.ground
        case .rock: Color.types.rock
        case .bug: Color.types.bug
        case .ghost: Color.types.ghost
        case .steel: Color.types.steel
        case .fire: Color.types.fire
        case .water: Color.types.water
        case .grass: Color.types.grass
        case .electric: Color.types.electric
        case .psychic: Color.types.psychic
        case .ice: Color.types.ice
        case .dragon: Color.types.dragon
        case .dark: Color.types.dark
        case .fairy: Color.types.fairy
        case .shadow: Color.types.shadow
        }
    }
    
    var image: String {
        switch self {
        case .normal: "circle.circle"
        case .fighting: "figure.boxing"
        case .flying: "bird.fill"
        case .poison: "bubbles.and.sparkles.fill"
        case .ground: "mountain.2.fill"
        case .rock: "fossil.shell.fill"
        case .bug: "ladybug"
        case .ghost: "ev.plug.dc.chademo"
        case .steel: "hexagon"
        case .fire: "flame"
        case .water: "drop.degreesign.fill"
        case .grass: "leaf.fill"
        case .electric: "bolt.fill"
        case .psychic: "swirl.circle.righthalf.filled"
        case .ice: "snowflake"
        case .dragon: "lizard.fill"
        case .dark: "moon.circle.fill"
        case .fairy: "sparkles"
        case .shadow: "circle.lefthalf.filled.righthalf.striped.horizontal"
        }
    }
}

struct ClassType: Identifiable, Decodable, Hashable {
    let id: Int
    let type: PokemonClassType
    let pokemon: [PKMNamedAPIResource<PKMPokemon>]
    
    init(id: Int, name: String, pokemon: [PKMNamedAPIResource<PKMPokemon>]) {
        self.id = id
        self.type = PokemonClassType(rawValue: name) ?? .normal
        self.pokemon = pokemon
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(pokemon)
    }
    
    public static func == (lhs: ClassType, rhs: ClassType) -> Bool {
        return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.pokemon == rhs.pokemon
    }
}
