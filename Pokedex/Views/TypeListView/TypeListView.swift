//
//  TypeListView.swift
//  Pokedex
//
//  Created by Luke Taylor on 07/03/2024.
//

import SwiftUI
import PokemonAPI

struct TypeListView: View {
    
    @EnvironmentObject private var router: Router
    
    @StateObject var viewModel = TypeListViewModel()

    var body: some View {
        Group {
            if !viewModel.isLoading {
                GeometryReader { geometry in
                    ScrollView {
                        SearchInputView(searchItem: $viewModel.searchItem,
                                        changeAction: {
                            viewModel.handleOnChangeEvent()
                        })
                        .padding()
                        
                        LazyVGrid(columns: viewModel.columns, alignment: .center, spacing: 15) {
                            ForEach(viewModel.types) { type in
                                let width = geometry.size.width / 2 - 20
                                
                                Button {
                                    router.navigate(to: type.pokemon)
                                } label: {
                                    ZStack {
                                        HStack {
                                            Text(type.type.name)
                                                .foregroundStyle(Color.core.white)
                                                .font(.system(size: 24))
                                                .fontWeight(.semibold)
                                            Spacer()
                                        }
                                        .padding()
                                        
                                        
                                        Image(systemName: type.type.image)
                                            .foregroundStyle(Color.core.white)
                                            .scaleEffect(3)
                                            .position(x: width - 30,
                                                      y: 35)
                                            .opacity(0.3)
                                        
                                    }
                                    .frame(width: width, height: 70, alignment: .center)
                                    .background(type.type.color)
                                    .cornerRadius(40)
                                    .shadow(color: .core.lightGrey,
                                            radius: 4,
                                            x: 0,
                                            y: 8)
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                        .listStyle(PlainListStyle())
                        .navigationDestination(for: [PKMNamedAPIResource<PKMPokemon>].self) { pokemon in
                            PokemonListView(pokemon: pokemon)
                        }
                    }
                }
            } else {
                LoadingView()
            }
        }
        .task {
            await viewModel.getTypeList()
        }
        .background(Color.core.white)
    }
}

#Preview {
    TypeListView()
}

