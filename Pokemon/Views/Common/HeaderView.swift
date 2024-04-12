//
//  HeaderView.swift
//  Pokemon
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct HeaderView: View {
    
    let pokemon: PokemonType
    let keyColor: Color
    
    @Binding var isFavourited: Bool
    
    var body: some View {
        let fontColor = keyColor.luminance() > 0.5 ? Color.core.black : Color.core.white
        HStack {
            Image("pokeball")
                .resizable()
                .frame(width:30, height:30)
                .fontWeight(.bold)
                .rotationEffect(.degrees(-45))
                .foregroundStyle(fontColor)
            
            Text(pokemon.name)
                .font(.system(size: 30))
                .padding(.leading, 10)
                .foregroundStyle(fontColor)
            
            Text("#\(pokemon.id)")
                .font(.system(size: 24))
                .padding(.leading, 10)
                .foregroundStyle(fontColor)
            
            Spacer()
            
            
            Button {
                isFavourited.toggle()
            } label: {
                Image(systemName: isFavourited ? "heart.fill" : "heart")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isFavourited ? Color.core.red : fontColor)
                    .frame(width: 30, height: 30)
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .foregroundStyle(.white)
        .background(keyColor)
    }
}

#Preview {
    let pokemon = PokemonType(id: 151,
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
    
    return HeaderView(pokemon: pokemon,
                      keyColor: .core.pink,
                      isFavourited: .constant(true))
}
