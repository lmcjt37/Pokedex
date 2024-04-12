//
//  BackgroundView.swift
//  Pokedex
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct BackgroundView: View {
    
    let pokemonImage: String
    let proxy: GeometryProxy
    let keyColor: Color
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.core.white)
                .scaleEffect(2.2)
                .position(x: proxy.size.width / 2,
                          y: proxy.size.height * 0.9)
            
            Circle()
                .fill(RadialGradient(colors: [keyColor, .clear, .clear],
                                     center: .center,
                                     startRadius: 0,
                                     endRadius: proxy.size.width))
                .foregroundStyle(.clear)
                .frame(width: proxy.size.width,
                       height: proxy.size.width * 1.5)
                .position(x: proxy.size.width / 2,
                          y: proxy.size.width / 1.6)
            
            Image("pokeball")
                .resizable()
                .frame(width: proxy.size.width * 0.9, height: proxy.size.width * 0.9)
                .fontWeight(.bold)
                .rotationEffect(.degrees(-45))
                .foregroundStyle(.white)
                .opacity(0.2)
                .position(x: proxy.size.width / 2,
                          y: proxy.size.width / 1.8)
            
            ImageView(withURL: pokemonImage)
                .position(x: proxy.size.width / 2,
                          y: proxy.size.width / 1.8)
            
            
        }
    }
}

#Preview {
    GeometryReader { geometry in
        BackgroundView(pokemonImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png",
                       proxy: geometry,
                       keyColor: .core.pink)
    }
    .background(Color.core.grey)
}
