//
//  PokemonType.swift
//  Pokemon
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI
import PokemonAPI

struct PokemonWeight: Decodable, Hashable {
    let value: Int
    
    var kilograms: String {
        String(format: "%.1f", Double(value) / 10) // converts hectograms to kilograms
    }
    
    var pounds: String {
        let kgs = Double(value) / 10
        return String(format: "%.1f", kgs * 2.20462) // converts to pounds
    }
}

struct PokemonHeight: Decodable, Hashable {
    let value: Int
    
    var metres: String {
        String(format: "%.1f", Double(value) / 10) // converts decimetres to metres
    }
    
    var feet: String {
        let feet = Double(value) / 10 * 3.28084 // converts to feet
        let feetMeasurement = Measurement(value: feet, unit: UnitLength.feet)
        return feetMeasurement.formatted(.measurement(width: .narrow, usage: .personHeight))
    }
}

enum StatName: String, Decodable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case speed = "speed"
    case s_attack = "special-attack"
    case s_defense = "special-defense"
}

typealias IdentifiableDecodeHash = Identifiable & Decodable & Hashable

struct PokemonStat: IdentifiableDecodeHash {
    var id = UUID()
    let base: Int
    let name: StatName
    
    var color: Color {
        switch name {
        case .hp:
            return Color.core.red
        case .attack:
            return Color.core.orange
        case .defense:
            return Color.core.yellow
        case .s_attack:
            return Color.core.blue
        case .s_defense:
            return Color.core.green
        case .speed:
            return Color.core.pink
        }
    }
    
    var shortName: String {
        switch name {
        case .hp:
            return "HP"
        case .attack:
            return "ATK"
        case .defense:
            return "DEF"
        case .s_attack:
            return "SATK"
        case .s_defense:
            return "SDEF"
        case .speed:
            return "SPD"
        }
    }
}

enum DamageClassType: String, Decodable {
    case status
    case special
    case physical
}

struct DamageClass: IdentifiableDecodeHash {
    var id = UUID()
    let name: DamageClassType
    
    var color: Color {
        switch name {
        case .status:
            return Color.core.red
        case .special:
            return Color.core.grey
        case .physical:
            return Color.core.coral
        }
    }
}

struct MoveType: IdentifiableDecodeHash {
    var id = UUID()
    let type: PokemonClassType
    let damageClass: DamageClass
    let accuracy: Int
    let pp: Int
    let power: Int
}

struct PokemonMove: IdentifiableDecodeHash {
    var id = UUID()
    let name: String
    let stats: MoveType
}

struct PokemonEvolutionLink: IdentifiableDecodeHash {
    var id = UUID()
    let name: String
    let url: String
}

struct PokemonEvolution: IdentifiableDecodeHash {
    var id = UUID()
    let name: String
    let image: String
    let types: [PokemonClassType]
    let evolvesFrom: PokemonEvolutionLink?
}

struct PokemonGame: IdentifiableDecodeHash {
    var id = UUID()
    let version: String
    let generation: String
}

struct PokemonLocation: IdentifiableDecodeHash {
    let id: Int
    let name: String
    let region: String
    let games: [PokemonGame]
}

struct PokemonType: IdentifiableDecodeHash {
    let id: Int
    let name: String
    let description: String
    let image: String
    let types: [PokemonClassType]
    let height: PokemonHeight
    let weight: PokemonWeight
    let strengths: [PokemonClassType]
    let stats: [PokemonStat]
    let moves: [PokemonMove]
    let evolutions: [PokemonEvolution]
    let locations: [PokemonLocation]
}

//--------

//struct PokemonVersionNew: IdentifiableDecodeHash {
//    var id = UUID()
//    let name: String
//    let versions: [PokemonLocationNew]
//}
//
//struct PokemonGeneration: IdentifiableDecodeHash {
//    var id = UUID()
//    let name: String
//    let versions: [PokemonVersionNew]
//}
//
//struct PokemonLocationNew: IdentifiableDecodeHash {
//    var id = UUID()
//    let name: String
//    let region: String
//    let generations: [PokemonGeneration]
//}
