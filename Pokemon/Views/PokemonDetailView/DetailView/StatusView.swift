//
//  StatusView.swift
//  Pokemon
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct StatusView: View {
    
    let stats: [PokemonStat]
    
    var body: some View {
        VStack {
            ForEach(stats) { stat in
                HStack(alignment: .center) {
                    Text(stat.shortName)
                        .frame(width: 60, alignment: .leading)
                        .foregroundStyle(Color.core.black)
                    
                    ZStack {
                        ProgressView(value: Double(stat.base > 100 ? 100 : stat.base),
                                     total: 100)
                        .progressViewStyle(BarProgressStyle(color: stat.color,
                                                            height: 25))

                        HStack {
                            Spacer()
                            Text(String(stat.base))
                                .padding(.trailing, 10)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.core.black)
                        }
                    }
                    .frame(maxHeight: 25)
                }
            }
            
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    let mockStats = [Pokemon.PokemonStat(base: 10, name: .hp),
                     Pokemon.PokemonStat(base: 30, name: .attack),
                     Pokemon.PokemonStat(base: 50, name: .defense),
                     Pokemon.PokemonStat(base: 70, name: .s_attack),
                     Pokemon.PokemonStat(base: 90, name: .s_defense),
                     Pokemon.PokemonStat(base: 110, name: .speed)]
    
    return StatusView(stats: mockStats)
    
}
