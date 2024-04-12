//
//  TypesView.swift
//  Pokedex
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct TypesView: View {
    
    let types: [PokemonClassType]
    
    var body: some View {
        HStack {
            ForEach(types) {
                type in
                Text(type.name)
                    .font(.system(size: 16))
                    .frame(width: 90, height: 25)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(type.color)
                    .foregroundStyle(Color.core.black)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white, lineWidth: 3))
            }
        }
    }
}

#Preview {
    TypesView(types: [PokemonClassType.psychic, PokemonClassType.bug])
}
