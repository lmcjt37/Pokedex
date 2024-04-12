//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI
import PokemonAPI

@MainActor
class PokemonListViewModel: ObservableObject {
       
    @Published var pokemon: [ListItemType] = []
    @Published var hasError = false
    @Published var isLoading = false
    @Published var searchItem = ""
    @Published var isLoaded = false
    @Published private var pokemonList: [ListItemType] = []
    @Published private var didFetchAll = false
    
    let pokemonService = PkmnService()

    func getPokemonList(pokemon: [PKMAPIResource<PKMPokemon>]) async {
        guard !isLoaded else { return }
        
        isLoading = true
        do {
            if (pokemon.count > 0) {
                var result: [ListItemType] = []
                
                await pokemon.concurrentForEach { item in
                    let resourceItem = try? await PokemonAPI().resourceService.fetch(item)
                    if let rItem = resourceItem,
                        let id = rItem.id,
                        let name = rItem.name,
                        let image = rItem.sprites?.frontDefault,
                        let resourceUrl = item.url {
                        let pkmnItem = ListItemType(id: id,
                                                    name: name,
                                                    image: image,
                                                    resourceUrl: resourceUrl)
                        
                        result.append(pkmnItem)
                    }
                }
                let sorted = result.sorted { $0.id < $1.id }
                self.pokemon = sorted
                self.pokemonList = sorted
            } else {
                didFetchAll = true
                let response = try await pokemonService.fetchAllPokemon()
                let sorted = response.sorted { $0.id < $1.id }
                self.pokemon = sorted
                self.pokemonList = sorted
            }
            
            hasError = false
            isLoading = false
            isLoaded = true
        } catch (let error) {
            self.pokemon = []
            self.pokemonList = []
            self.hasError = true
            isLoading = false
            print(error.localizedDescription)
        }
    }
    
    func handleOnChangeEvent() {
        if (searchItem.isEmpty) {
            pokemon = pokemonList
            return
        }
        pokemon = pokemonList.filter { $0.name.lowercased().contains(searchItem.lowercased()) }
    }
    
    func shouldLoadMore(id: Int) async {
        let searchIndex = pokemon.count - 2
        if didFetchAll, searchItem.isEmpty, id == pokemon[searchIndex].id {
            await self.loadmore()
        }
    }
    
    private func loadmore() async {
        guard let pageObject = pokemonService.allPokemonPagedObject, pageObject.hasNext else { return }
        
        do {
            let result = try await pokemonService.fetchAllPokemonNext()
            let sorted = result.sorted { $0.id < $1.id }
            self.pokemon.append(contentsOf: sorted)
            self.pokemonList.append(contentsOf: sorted)
            hasError = false
        } catch (let error) {
            self.pokemon = []
            self.pokemonList = []
            self.hasError = true
            print(error.localizedDescription)
        }
    }
}
