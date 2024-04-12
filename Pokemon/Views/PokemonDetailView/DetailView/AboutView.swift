//
//  AboutView.swift
//  Pokemon
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct AboutView: View {
    
    let pokemon: PokemonType
    let proxy: GeometryProxy
    
    var body: some View {
        VStack {
            Text(pokemon.description)
                .foregroundStyle(Color.core.black)
                .padding(20)
                .italic()
                .lineLimit(3)
            
            SizeView(height: pokemon.height,
                     weight: pokemon.weight)
            
            StrengthsView(strengths: pokemon.strengths,
                          proxy: proxy)
            
        }
    }
}

#Preview {
    let mockPokemon = PokemonType(id: 151,
                              name: "Mew",
                              description: "When viewed through a microscope, this Pokémon’s short, fine, delicate hair can be seen.",
                              image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png",
                              types: [Pokemon.PokemonClassType.psychic],
                              height: Pokemon.PokemonHeight(value: 4),
                              weight: Pokemon.PokemonWeight(value: 40),
                              strengths: [Pokemon.PokemonClassType.fighting, Pokemon.PokemonClassType.poison],
                              stats: [Pokemon.PokemonStat(base: 100, name: .hp), Pokemon.PokemonStat(base: 100, name: .attack), Pokemon.PokemonStat(base: 100, name: .defense), Pokemon.PokemonStat(base: 100, name: .s_attack), Pokemon.PokemonStat(base: 100, name: .s_defense), Pokemon.PokemonStat(base: 100, name: .speed)],
                              moves: [
                                  PokemonMove(name: "pound",
                                              stats: MoveType(type: .normal,
                                                              damageClass: DamageClass(name: .physical),
                                                              accuracy: 100,
                                                              pp: 35,
                                                              power: 40)),
                                  PokemonMove(name: "confusion",
                                              stats: MoveType(type: .psychic,
                                                              damageClass: DamageClass(name: .special),
                                                              accuracy: 100,
                                                              pp: 25,
                                                              power: 50))],
                              evolutions: [],
    locations: [])
    
    return GeometryReader { geometry in
        AboutView(pokemon: mockPokemon, proxy: geometry)
    }
}
