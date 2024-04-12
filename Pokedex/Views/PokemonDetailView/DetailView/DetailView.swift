//
//  DetailView.swift
//  Pokedex
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI

struct DetailView: View {
    
    let pokemon: PokemonType
    let moveSet: [[PokemonMove]]
    let keyColor: Color
    
    @Binding var isFavourited: Bool
    
    @State private var selectedOption: OptionTypes = .About
    
    var body: some View {
        GeometryReader { geometry in
            
            keyColor.ignoresSafeArea()
            
            ZStack {
                
                HeaderView(pokemon: pokemon,
                           keyColor: keyColor,
                           isFavourited: $isFavourited)
                .position(x: geometry.size.width / 2, 
                          y: geometry.safeAreaInsets.top / 2)
                
                BackgroundView(pokemonImage: pokemon.image,
                               proxy: geometry,
                               keyColor: keyColor )
                
                VStack {
                    Spacer()
                    
                    VStack {
                        TypesView(types: pokemon.types)
                        
                        CustomSegmentView(keyColor: keyColor,
                                          selectedOption: $selectedOption)
                        
                        switch selectedOption {
                        case .About:
                            AboutView(pokemon: pokemon,
                                      proxy: geometry)
                        case .Status:
                            StatusView(stats: pokemon.stats)
                        case .Moves:
                            MovesView(moveSet: moveSet,
                                      proxy: geometry,
                                      keyColor: keyColor)
                        }
                    }
                    .frame(height: geometry.size.height * 0.5)
                }
            }
        }
        .background(Color.core.white)
    }
}

#Preview {
    let mockPokemon = PokemonType(id: 151,
                              name: "Mew",
                              description: "When viewed through a microscope, this Pokémon’s short, fine, delicate hair can be seen.",
                              image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png",
                              types: [PokemonClassType.psychic],
                              height: PokemonHeight(value: 4),
                              weight: PokemonWeight(value: 40),
                              strengths: [PokemonClassType.fighting,
                                          PokemonClassType.poison],
                              stats: [PokemonStat(base: 100, name: .hp),
                                      PokemonStat(base: 100, name: .attack),
                                      PokemonStat(base: 100, name: .defense),
                                      PokemonStat(base: 100, name: .s_attack),
                                      PokemonStat(base: 100, name: .s_defense),
                                      PokemonStat(base: 100, name: .speed)],
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
    
    let mockMoveSet = [[
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
                                    power: 50))], [
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
                                                                    power: 50))]]
    
    return DetailView(pokemon: mockPokemon,
                      moveSet: mockMoveSet,
                      keyColor: .core.pink,
                      isFavourited: .constant(false))
    
}
