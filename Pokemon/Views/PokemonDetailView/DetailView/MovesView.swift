//
//  MovesView.swift
//  Pokemon
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct MovesView: View {
    
    @State private var selectedTabIndex = 0
    
    let moveSet: [[PokemonMove]]
    let proxy: GeometryProxy
    let keyColor: Color
    
    var body: some View {
        TabView(selection: $selectedTabIndex.animation()) {
            ForEach(Array(moveSet.enumerated()), id: \.element) { idx, moves in
                HStack {
                    ForEach(Array(moves.enumerated()), id: \.element) { index, move in
                        VStack {
                            Text(move.name.capitalized)
                                .foregroundStyle(Color.core.grey)
                                .font(.system(size: 18))
                                .padding(.bottom, 8)
                                .fixedSize(horizontal: false,
                                           vertical: true)
                            
                            Text(move.stats.type.name)
                                .font(.system(size: 16))
                                .frame(width: 90, height: 25)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .foregroundStyle(Color.core.white)
                                .background(move.stats.type.color)
                                .cornerRadius(20)
                                .padding(.bottom, 8)
                            
                            Text(move.stats.damageClass.name.rawValue.capitalized)
                                .font(.system(size: 16))
                                .frame(width: 90, height: 25)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .foregroundStyle(Color.core.white)
                                .background(move.stats.damageClass.color)
                                .cornerRadius(20)
                                .padding(.bottom, 8)
                            
                            HStack(spacing: 15) {
                                VStack {
                                    Text("PWR")
                                        .foregroundStyle(Color.core.grey)
                                        .padding(.bottom, 8)
                                    Text(String(move.stats.power))
                                        .foregroundStyle(Color.core.black)
                                }
                                VStack {
                                    Text("ACC")
                                        .foregroundStyle(Color.core.grey)
                                        .padding(.bottom, 8)
                                    Text("\(move.stats.accuracy)%")
                                        .foregroundStyle(Color.core.black)
                                }
                                VStack {
                                    Text("PP")
                                        .foregroundStyle(Color.core.grey)
                                        .padding(.bottom, 8)
                                    Text(String(move.stats.pp))
                                        .foregroundStyle(Color.core.black)
                                }
                            }
                        }
                        .frame(minWidth: proxy.size.width / 2 - 10)
                        
                        if index == 0 && moves.count == 2 {
                            Rectangle()
                                .frame(width: 1, height: proxy.size.height / 4)
                                .foregroundStyle(Color.core.grey)
                                .padding(.vertical)
                        }
                        
                        if moves.count == 1 {
                            Spacer()
                        }
                    }
                }
                .tag(idx)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        
        if (moveSet.count > 1) {
            Fancy3DotsIndexView(numberOfPages: moveSet.count,
                                currentIndex: selectedTabIndex,
                                primaryColor: keyColor,
                                secondaryColor: keyColor.opacity(0.6))
        }
    }
}

#Preview {
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
    
    return GeometryReader { geometry in
        VStack {
            MovesView(moveSet: mockMoveSet, proxy: geometry, keyColor: .core.pink)
        }
    }
    
    
}
