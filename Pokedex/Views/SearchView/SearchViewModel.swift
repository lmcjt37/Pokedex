//
//  SearchViewModel.swift
//  Pokedex
//
//  Created by Luke Taylor on 04/03/2024.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var pokemon: ListItemType? = nil
    @Published var hasError = false
    @Published var isLoading = false
    @Published var searchItem: String = ""
    
    @State var isLoaded = false

    func fetchPokomon(_ name: String) async {
        guard !isLoaded else { return }
        
        isLoading = true
        do {
            self.pokemon = try await PkmnService().searchPokemonByName(name.lowercased())
            hasError = false
            isLoading = false
            isLoaded = true
        } catch(let error) {
            self.pokemon = nil
            self.hasError = true
            isLoading = false
            print(error.localizedDescription)
        }
    }
}
