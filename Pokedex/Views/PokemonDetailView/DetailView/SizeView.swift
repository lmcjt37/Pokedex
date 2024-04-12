//
//  SizeView.swift
//  Pokedex
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct SizeView: View {
    
    let height: PokemonHeight
    let weight: PokemonWeight
    
    var body: some View {
        HStack(spacing: 40) {
            VStack(alignment: .leading) {
                Text("Height")
                    .foregroundStyle(Color.core.grey)
                Text("Weight")
                    .foregroundStyle(Color.core.grey)
                    .padding(.top, 5)
            }
            
            VStack(alignment: .leading) {
                Text(height.feet)
                    .foregroundStyle(Color.core.black)
                Text("\(weight.pounds) lbs")
                    .foregroundStyle(Color.core.black)
                    .padding(.top, 5)
            }
            
            VStack(alignment: .leading) {
                Text("\(height.metres) m")
                    .foregroundStyle(Color.core.black)
                Text("\(weight.kilograms) kg")
                    .foregroundStyle(Color.core.black)
                    .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SizeView(height: PokemonHeight(value: 4), 
             weight: PokemonWeight(value: 40))
}
