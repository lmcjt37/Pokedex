//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by Luke Taylor on 13/03/2024.
//

import Foundation
import SwiftUI

struct NamedPokemonLocation {
    let id: Int
    let name: String
    let region: String
}

typealias LocationDictionary = Dictionary<String, Dictionary<String, [NamedPokemonLocation]>>

@MainActor
class DetailViewModel: ObservableObject {
    
    @Published var pokemon: PokemonType?
    @Published var moveSet: [[PokemonMove]] = []
    @Published var locationSet: LocationDictionary = [:]
    @Published var keyColor: Color = .core.grey
    @Published var hasError = false
    @Published var isLoading = false
    @Published var searchItem: String = ""
    @Published var isFavourited: Bool = false
    
    @State var isLoaded = false
    

    func fetchPokemon(_ name: String) async {
        guard !isLoaded else { return }
        
        isLoading = true
        do {
            pokemon = try await PkmnService().fetchPokemonByName(name.lowercased())
            moveSet = getMoves()
            locationSet = getLocations()
            print(">>>> \(locationSet)")
            
            if let pkmn = pokemon, let firstType = pkmn.types.first {
                keyColor = firstType.color
            }
            
            hasError = false
            isLoading = false
            isLoaded = true
        } catch(let error) {
            pokemon = nil
            moveSet = []
            hasError = true
            isLoading = false
            print(error.localizedDescription)
        }
    }
    
    fileprivate func getMoves() -> [[PokemonMove]] {
        var moveSet: [[PokemonMove]] = []
        var moves: [PokemonMove] = []
        var indexCount = 0
        
        guard let pkmn = pokemon else { return moveSet }
        
        for move in pkmn.moves {
            if indexCount < 2 {
                moves.append(move)
                indexCount += 1
            } else {
                moveSet.append(moves)
                moves = [move]
                indexCount = 1
            }
        }
        
        if !moves.isEmpty {
            moveSet.append(moves)
            moves = []
        }
        
        return moveSet
    }
    
    fileprivate func getLocations() -> LocationDictionary {
        var generationGroup: LocationDictionary = [:]
        var versionGroup: Dictionary<String, [NamedPokemonLocation]> = [:]
        
        guard let pkmn = pokemon else { return generationGroup }
        
        for location in pkmn.locations {
            let namedLocation = NamedPokemonLocation(id: location.id,
                                                     name: location.name,
                                                     region: location.region.capitalized)
            for game in location.games {
                let generationSplits = game.generation.split(separator: "-")
                let generationText = (generationSplits.first?.capitalized)!
                let numerals = (generationSplits.last?.uppercased())!
                let generation = generationText + " " + numerals
                let gameVersion = game.version
                
                if generationGroup.keys.contains(generation) {
                    if versionGroup.keys.contains(gameVersion) {
                        var version = versionGroup[gameVersion]
                        version?.append(namedLocation)
                    } else {
                        versionGroup.updateValue([namedLocation], forKey: gameVersion)
                    }
                } else {
                    generationGroup.updateValue([gameVersion: [namedLocation]], forKey: generation)
                }
                
//                if generationGroup.keys.contains(game.generation) {
//                    if versionGroup.keys.contains(game.version) {
//                        var version = versionGroup[game.version]
//                        version?.append(namedLocation)
//                    } else {
//                        versionGroup.updateValue([namedLocation], forKey: game.version)
//                    }
//                } else {
//                    generationGroup.updateValue([game.version: [namedLocation]], forKey: game.generation)
//                }
            }
        }
        
        return generationGroup
    }
}

enum OptionTypes: String, Identifiable {
    case About
    case Status
    case Moves
    
    var id: String { return rawValue }
}
