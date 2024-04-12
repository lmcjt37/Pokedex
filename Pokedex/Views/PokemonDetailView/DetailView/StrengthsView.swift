//
//  StrengthsView.swift
//  Pokedex
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI
import WrappingHStack

struct StrengthsView: View {
    
    let strengths: [PokemonClassType]
    let proxy: GeometryProxy
    
    var body: some View {
        HStack {
            
            VStack {
                Text("Strong against")
                    .foregroundStyle(Color.core.grey)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.top, 10)
                    .padding(.trailing, 5)
                
                Spacer()
            }
            
            
            VStack {
                WrappingHStack(strengths,
                               alignment: .leading,
                               spacing: .constant(5),
                               lineSpacing: 5) { strength in
                    
                    Image(systemName: strength.image)
                        .frame(width: 25, height: 25)
                        .padding(8)
                        .background(strength.color)
                        .foregroundStyle(Color.core.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white, lineWidth: 2))
                    
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
}

#Preview {
    let mockStrengths = [PokemonClassType.fighting, PokemonClassType.poison]
    
    return GeometryReader { geometry in
        StrengthsView(strengths: mockStrengths, proxy: geometry)
    }
}
