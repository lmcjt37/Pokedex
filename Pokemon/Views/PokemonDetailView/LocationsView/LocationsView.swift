//
//  LocationsView.swift
//  Pokemon
//
//  Created by Luke Taylor on 25/03/2024.
//

import SwiftUI

struct LocationsView: View {
    
    let pokemon: PokemonType
    let locations: [PokemonLocation]
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
                        
                        Text("Locations")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.core.black)
                            .padding(.top, 100)
                        
                        
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .background(LinearGradient(gradient: Gradient(colors: [keyColor, keyColor, .core.white, .core.white]),
                                       startPoint: .top,
                                       endPoint: .bottom))
            .toolbar(.hidden, for: .tabBar)
            
            HeaderView(pokemon: pokemon,
                       keyColor: keyColor,
                       isFavourited: $isFavourited)
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
    
    return LocationsView(pokemon: mockPokemon,
                         locations: [],
                         keyColor: Color.core.yellow,
                         isFavourited: .constant(false))
}

