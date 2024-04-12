//
//  EvolutionsView.swift
//  Pokedex
//
//  Created by Luke Taylor on 25/03/2024.
//

import SwiftUI

struct EvolutionsView: View {
    
    let pokemon: PokemonType
    let evolutions: [PokemonEvolution]
    let keyColor: Color
    
    @Binding var isFavourited: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack (alignment: .top) {
                    keyColor.ignoresSafeArea()
                    
                    Circle()
                        .fill(Color.core.white)
                        .scaleEffect(2.2)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.width * 1.25)
                    
                    VStack (alignment: .center) {
                        
                        Text("Evolutions")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.core.black)
                            .padding(.top, 100)
                        
                        VStack (alignment: .center) {
                            
                            ForEach(evolutions) { evolution in
                                EvolutionLinkView(evolution: evolution,
                                                  keyColor: keyColor,
                                                  geometry: geometry)
                            }
                        }
                        .padding(.top, -40)
                        
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .background(LinearGradient(gradient: Gradient(colors: [keyColor, keyColor, .core.white, .core.white]), 
                                       startPoint: .top,
                                       endPoint: .bottom))
            
            HeaderView(pokemon: pokemon, 
                       keyColor: keyColor,
                       isFavourited: $isFavourited)
        }
    }
}

struct EvolutionLinkView: View {
    
    let evolution: PokemonEvolution
    let keyColor: Color
    let geometry: GeometryProxy
    
    var body: some View {
        if evolution.evolvesFrom != nil {
            Image(systemName: "arrow.down")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.top, 30)
                .padding(.bottom, -10)
                .foregroundStyle(Color.core.black)
            
        }
        
        ZStack (alignment: .center) {
            ImageView(withURL: evolution.image)
                .frame(maxHeight: 200)
                .aspectRatio(contentMode: .fill)
                .shadow(color: keyColor.opacity(0.6), radius: 25)
            
            VStack {
                Text(evolution.name.capitalized)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.core.black)
                    .padding(-4)
                TypesView(types: evolution.types)
            }
            .position(x: geometry.size.width / 2,
                      y: 200)
        }
    }
}


#Preview {
    let mockPokemon =  PokemonType(id: 151,
                                name: "Mew",
                                description: "When viewed through a microscope, this Pokémon’s short, fine, delicate hair can be seen.",
                                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png",
                                types: [PokemonClassType.psychic],
                                height: PokemonHeight(value: 4),
                                weight: PokemonWeight(value: 40),
                                strengths: [PokemonClassType.fighting, PokemonClassType.poison],
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
    
    return EvolutionsView(pokemon: mockPokemon,
                          evolutions: [
                            
                            PokemonEvolution(name: "pichu",
                                             image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/172.png",
                                             types: [PokemonClassType.electric],
                                             evolvesFrom: nil),
                            PokemonEvolution(name: "pikachu",
                                             image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
                                             types: [PokemonClassType.electric],
                                             evolvesFrom: PokemonEvolutionLink(name: "pichu",
                                                                               url: "https://pokeapi.co/api/v2/pokemon-species/172/")),
                            PokemonEvolution(name: "raichu",
                                             image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/26.png",
                                             types: [PokemonClassType.electric],
                                             evolvesFrom: PokemonEvolutionLink(name: "pikachu",
                                                                               url: "https://pokeapi.co/api/v2/pokemon-species/25/"))],
                          keyColor: Color.core.yellow,
                          isFavourited: .constant(false))
}
