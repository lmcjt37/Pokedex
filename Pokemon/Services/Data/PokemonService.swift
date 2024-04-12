//
//  PokemonService.swift
//  Pokemon
//
//  Created by Luke Taylor on 28/02/2024.
//

import PokemonAPI
import SwiftUI

protocol PkmnServiceProtocol {
    var allPokemonPagedObject: PKMPagedObject<PKMPokemon>? { get set }
    
    func fetchAllPokemon(_ size: Int) async throws -> [ListItemType]
    func fetchAllPokemonNext(_ size: Int) async throws -> [ListItemType]
    func searchPokemonByName(_ name: String) async throws -> ListItemType
    func fetchPokemonById(_ id: Int) async throws -> PokemonType
    func fetchPokemonByName(_ name: String) async throws -> PokemonType
    func fetchAllTypes() async throws -> [ClassType]
}

enum ServiceError: Error {
    case validation
    case url
}

struct BaseUrl {
    static let root = "https://pokeapi.co/api/v2/"
    static let pokemon = "https://pokeapi.co/api/v2/pokemon/"
}

class PkmnService: PkmnServiceProtocol {
    
    var allPokemonPagedObject: PKMPagedObject<PKMPokemon>?
    
    let pokemonAPI: PokemonAPI = PokemonAPI()
    
    /// Pokemon
    
    func fetchAllPokemon(_ size: Int = 20) async throws -> [ListItemType] {
        
        var result: [ListItemType] = []
        
        self.allPokemonPagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: .initial(pageLimit: size))
        
        let resourceList = allPokemonPagedObject?.results
        
        await resourceList?.concurrentForEach { [self] item in
            let rItem = try? await pokemonAPI.resourceService.fetch(item)
            
            guard let resourceItem = rItem else { return }
            
            if let id = resourceItem.id, 
                let name = resourceItem.name,
                let image = resourceItem.sprites?.frontDefault, 
                let resourceUrl = item.url {
                
                let pkmnItem = ListItemType(id: id,
                                            name: name,
                                            image: image, resourceUrl: resourceUrl)
                result.append(pkmnItem)
            }
            
        }
        
        return result
    }
    
    func fetchAllPokemonNext(_ size: Int = 20) async throws -> [ListItemType] {
        
        var result: [ListItemType] = []
        
        guard let _ = self.allPokemonPagedObject else { return [] }
        
        self.allPokemonPagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: .continuing(self.allPokemonPagedObject!, .next))
        
        let resourceList = allPokemonPagedObject?.results
        
        await resourceList?.concurrentForEach { [self] item in
            let rItem = try? await pokemonAPI.resourceService.fetch(item)
            
            guard let resourceItem = rItem else { return }
            
            if let id = resourceItem.id,
               let name = resourceItem.name,
               let image = resourceItem.sprites?.frontDefault,
               let resourceUrl = item.url {
                
                let pkmnItem = ListItemType(id: id,
                                            name: name,
                                            image: image,
                                            resourceUrl: resourceUrl)
                result.append(pkmnItem)
            }
            
        }
        
        return result
    }
    
    func fetchPokemonById(_ id: Int) async throws -> PokemonType {
        let result = try await pokemonAPI.pokemonService.fetchPokemon(id)
        return try await fetchPokemonMetadata(pokemon: result)
    }
    
    func fetchPokemonByName(_ name: String) async throws -> PokemonType {
        let result = try await pokemonAPI.pokemonService.fetchPokemon(name)
        return try await fetchPokemonMetadata(pokemon: result)
    }
    
    func searchPokemonByName(_ name: String) async throws -> ListItemType {
        let result = try await pokemonAPI.pokemonService.fetchPokemon(name)
        guard let id = result.id, let name = result.name, let image = result.sprites?.frontDefault else {
            throw ServiceError.validation
        }
        return ListItemType(id: id, name: name, image: image, resourceUrl: BaseUrl.pokemon + String(id))
    }
    
    func fetchAllTypes() async throws -> [ClassType] {
        
        let typeExclusions = Set(["unknown", "shadow"]) // Unknown and shadow both provide unwanted results
        
        var result: [ClassType] = []
        
        let resourceList = try await pokemonAPI.pokemonService.fetchTypeList(paginationState: .initial(pageLimit: 25)).results
        
        await resourceList?.concurrentForEach { [self] item in
            let rItem = try? await pokemonAPI.resourceService.fetch(item)
            
            guard let resourceItem = rItem else { return }
            
            guard !typeExclusions.contains(resourceItem.name ?? "") else {
                return
            }
            
            if let pokemon = await resourceItem.pokemon?.asyncMap({ $0.pokemon! }),
                let id = resourceItem.id,
                let name = resourceItem.name {
                
                let filteredPokemon = pokemon.filter { pkmn in
                    if let name = pkmn.name {
                        return !name.contains("-") // exclude special pokemon
                    }
                    return false
                }
                
                result.append(ClassType(id: id, name: name, pokemon: filteredPokemon))
            }
            
        }
        
        let sorted = result.sorted { $0.type.name < $1.type.name }
        
        return sorted
    }
    
    /// Private
    
    private func fetchPokemonStrengths(types: [String]) async throws -> [PokemonClassType] {
        var result: [PokemonClassType] = []
        
        try await types.asyncForEach { name in
            let type = try await pokemonAPI.pokemonService.fetchType(name)
            if let doubleDamage = type.damageRelations?.doubleDamageTo {
                let strengths = doubleDamage
                    .compactMap { $0.name }
                    .compactMap { PokemonClassType(rawValue: $0) }
                
                result.append(contentsOf: strengths)
            }
        }
        
        return result.unique()
    }
    
    private func fetchPokemonDescription(pokemon: PKMPokemon) async throws -> String {
        var description: String = ""
        
        if let pkmnSpecies = pokemon.species, let speciesName = pkmnSpecies.name {
            let species = try await pokemonAPI.pokemonService.fetchPokemonSpecies(speciesName)
            
            if let flavorEntries = species.flavorTextEntries {
                let localeEntries = flavorEntries.filter { $0.language?.name == "en" }
                if let text = localeEntries.last?.flavorText {
                    description = text.replacingOccurrences(of: "\n", with: " ")
                }
            }
        }
        
        return description
    }
    
    private func fetchPokemonStats(stats: [PKMPokemonStat]) async throws -> [PokemonStat] {
        var result: [PokemonStat] = []
        
        stats.forEach { stat in
            if let base = stat.baseStat, let name = stat.stat?.name, let statName = StatName(rawValue: name) {
                result.append(PokemonStat(base: base, name: statName))
            }
        }
        
        return result
    }
    
    private func fetchPokemonMoves(moves: [PKMPokemonMove]) async throws -> [PokemonMove] {
        var result: [PokemonMove] = []
        var moveItems: [String] = []
        
        moves.forEach { move in
            if let details = move.versionGroupDetails {
                let filteredLevels = details.filter {
                    if let level = $0.levelLearnedAt {
                        return level <= 5 // target starter moves
                    }
                    return false
                }
                let filteredMethods = filteredLevels.filter {
                    return $0.moveLearnMethod?.name == "level-up" // specifically standard levelling moves
                }
                
                filteredMethods.forEach { method in
                    if let name = move.move?.name, !moveItems.contains(where: { $0 == name }) { // De-dupe moves by name
                        moveItems.append(name)
                    }
                }
            }
        }
        
        try await moveItems.asyncForEach { name in
            let response = try await pokemonAPI.moveService.fetchMove(name)
            if let type = response.type?.name,
               let classType = PokemonClassType(rawValue: type),
               let damageClass = response.damageClass,
               let damageClassName = damageClass.name,
               let damageClassType = DamageClassType(rawValue: damageClassName),
               let accuracy = response.accuracy,
               let pp = response.pp,
               let power = response.power {
                result.append(PokemonMove(name: name.replacingOccurrences(of: "-", with: " "),
                                          stats: MoveType(type: classType,
                                                          damageClass: DamageClass(name: damageClassType),
                                                          accuracy: accuracy,
                                                          pp: pp,
                                                          power: power)))
            }
            
        }
        
        return result
    }
    
    private func getEvolutionLink(chainData: [PKMClainLink]) -> [PokemonEvolutionLink] {
        var result: [PokemonEvolutionLink] = []
        
        chainData.forEach { link in
            if let name = link.species?.name,
                let url = link.species?.url {
                result.append(PokemonEvolutionLink(name: name, url: url))
            }
            if let chain = link.evolvesTo, chain.count > 0 {
                result.append(contentsOf: getEvolutionLink(chainData: chain))
            }
        }
        
        return result
    }
    
    private func fetchPokemonEvolutions(id: Int) async throws -> [PokemonEvolution] {
        var result: [PokemonEvolution] = []
        
        let species = try await pokemonAPI.pokemonService.fetchPokemonSpecies(id)
        
        guard let chain = species.evolutionChain, let url = chain.url else { throw ServiceError.validation }
        guard let component = URL(string: url)?.lastPathComponent, let chainId = Int(component) else { throw ServiceError.validation }
                
        let response = try await pokemonAPI.evolutionService.fetchEvolutionChain(chainId)
        
        var chainLinks: [PokemonEvolutionLink] = []
        if let name = response.chain?.species?.name,
            let url = response.chain?.species?.url {
            chainLinks.append(PokemonEvolutionLink(name: name, url: url))
        }
        if let chain = response.chain?.evolvesTo, chain.count > 0 {
            chainLinks.append(contentsOf: getEvolutionLink(chainData: chain))
        }
        
        await chainLinks.concurrentForEach { [self] link in
            let species = try? await pokemonAPI.pokemonService.fetchPokemonSpecies(link.name)
            let data = try? await pokemonAPI.pokemonService.fetchPokemon(link.name)
            
            if let name = data?.name, 
                let image = data?.sprites?.frontDefault,
                let resultTypes = data?.types {
                let (_, classTypes) = fetchPokemonTypes(types: resultTypes)
                
                var evolvesFrom: PokemonEvolutionLink? = nil
                if let evolvesFromName = species?.evolvesFromSpecies?.name,
                   let evolvesFromUrl = species?.evolvesFromSpecies?.url {
                    evolvesFrom = PokemonEvolutionLink(name: evolvesFromName,
                                                      url: evolvesFromUrl)
                }
                
                result.append(PokemonEvolution(name: name,
                                               image: image,
                                               types: classTypes,
                                               evolvesFrom: evolvesFrom))
            }
            
        }
        
        var sorting: [PokemonEvolution] = []
        result.forEach { item in
            if item.evolvesFrom == nil { // bottom of evolution chain
                sorting.insert(item, at: 0)
            } else if let foundIndex = sorting.firstIndex(where: { $0.name == item.evolvesFrom?.name }) { // previous evolution exists
                sorting.insert(item, at: foundIndex + 1)
            } else {
                sorting.append(item) // if chain position does not exist just append
            }
        }
        
        return sorting
    }
    
    private func fetchPokemonEncounters(id: Int) async throws -> [PKMLocationAreaEncounter] {
        guard let url = URL(string: BaseUrl.pokemon + "\(id)/encounters") else { throw ServiceError.url }
        
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let fetchedData = try decoder.decode([PKMLocationAreaEncounter].self, from: data)
        
        return fetchedData
    }
    
    private func fetchVersionByName(versionName: String) async throws -> PokemonServiceVersion {
        guard let url = URL(string: BaseUrl.root + "version/\(versionName)") else { throw ServiceError.url }
        
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let fetchedData = try decoder.decode(PokemonServiceVersion.self, from: data)
        
        return fetchedData
    }
    
    private func fetchPokemonLocations(id: Int) async throws -> [PokemonLocation] {
        var result: [PokemonLocation] = []
        
        let encounters = try await fetchPokemonEncounters(id: id)
        
        await encounters.concurrentForEach { [self] encounter in
            
            var games: [PokemonGame] = []
            if let versionDetails = encounter.versionDetails {
                await versionDetails.asyncForEach { version in
                    guard let versionName = version.version?.name else { return }
                    
                    let versionResponse = try? await fetchVersionByName(versionName: versionName)
                    guard let versionGroupResource = versionResponse?.versionGroup else { return }
                    
                    let versionGroupResponse = try? await pokemonAPI.resourceService.fetch(versionGroupResource)
                    if let generationName = versionGroupResponse?.generation?.name,
                        let versionNameActual = versionResponse?.names?.first(where: { $0.language?.name == "en" })?.name {
                        games.append(PokemonGame(version: versionNameActual, generation: generationName))
                    }
                }
            }
            
            guard let encounterResource = encounter.locationArea else { return }
            let locationAreaResponse = try? await pokemonAPI.resourceService.fetch(encounterResource)
            
            guard let locationResource = locationAreaResponse?.location else { return }
            let locationResponse = try? await pokemonAPI.resourceService.fetch(locationResource)
            
            if let locationNames = locationResponse?.names,
               let region = locationResponse?.region?.name {
                
                if let locationName = locationNames.first(where: { $0.language?.name == "en" })?.name,
                    let locationId = locationResponse?.id {
                    
                    let location = PokemonLocation(id: locationId,
                                                   name: locationName,
                                                   region: region, 
                                                   games: games.unique())
                    
                    result.append(location)
                }
            }
        }
        
        return result
    }
    
    private func fetchPokemonTypes(types: [PKMPokemonType]) -> ([String],[PokemonClassType]) {
        let typeNames = types
            .compactMap { $0.type }
            .compactMap { $0.name }
        return (typeNames, typeNames.compactMap { PokemonClassType(rawValue: $0) })
    }
    
    // TODO: break this method up to allow specific screens to fetch only what they need
    // e.g. Detail screen doesn't care about evolutions or locations
    //
    // We should always have some pokemon info to allow us to fetch onAppear.
    private func fetchPokemonMetadata(pokemon: PKMPokemon) async throws -> PokemonType {
        let description = try await fetchPokemonDescription(pokemon: pokemon)
        
        guard let id = pokemon.id,
              let name = pokemon.name,
              let image = pokemon.sprites?.frontDefault,
              let height = pokemon.height,
              let weight = pokemon.weight,
              let resultTypes = pokemon.types,
              let resultStats = pokemon.stats,
              let resultMoves = pokemon.moves else {
            throw ServiceError.validation
        }
        
        let (typeNames, classTypes) = fetchPokemonTypes(types: resultTypes)
        let strengths = try await fetchPokemonStrengths(types: typeNames)
        let stats = try await fetchPokemonStats(stats: resultStats)
        let moves = try await fetchPokemonMoves(moves: resultMoves)
        let evolutions = try await fetchPokemonEvolutions(id: id)
        let locations = try await fetchPokemonLocations(id: id)
        
        return PokemonType(id: id,
                           name: name.capitalized(with: .current),
                           description: description,
                           image: image,
                           types: classTypes,
                           height: PokemonHeight(value: height),
                           weight: PokemonWeight(value: weight),
                           strengths: strengths,
                           stats: stats,
                           moves: moves,
                           evolutions: evolutions,
                           locations: locations)
    }
}

extension PKMPokemon : Identifiable {}

extension PKMNamedAPIResource : Hashable {
    public static func == (lhs: PKMNamedAPIResource<T>, rhs: PKMNamedAPIResource<T>) -> Bool {
        return lhs.url == rhs.url && lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(name)
    }
}

// Fixes incorrect `versionGroup` decode - https://github.com/kinkofer/PokemonAPI/pull/28
open class PokemonServiceVersion: Codable, SelfDecodable {
    
    /// The identifier for this version resource
    open var id: Int?
    
    /// The name for this version resource
    open var name: String?
    
    /// The name of this version listed in different languages
    open var names: [PKMName]?
    
    /// The version group this version belongs to
    open var versionGroup: PKMNamedAPIResource<PKMVersionGroup>?
    
    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
