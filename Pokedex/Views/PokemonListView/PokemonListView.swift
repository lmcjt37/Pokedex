//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Luke Taylor on 28/02/2024.
//

import SwiftUI
import PokemonAPI

struct PokemonListView: View {
    
    @StateObject var viewModel = PokemonListViewModel()
    
    let pokemon: [PKMAPIResource<PKMPokemon>]?

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
                        
                        let width = geometry.size.width / 2 - 20
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: width, maximum: width)),
                            GridItem(.flexible(minimum: width, maximum: width))],
                                  spacing: 15) {
                            ForEach(viewModel.pokemon) { item in
                                NavigationLink(destination: DetailTabView(pokemon: item),
                                               label: {
                                    GridTileView(pokemon: item, geometry: geometry)
                                        .padding(.horizontal, 5)
                                        .onAppear {
                                            Task {
                                                await viewModel.shouldLoadMore(id: item.id)
                                            }
                                        }
                                })
                                
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                    }
                }
            } else {
                LoadingView()
            }
        }
        .task {
            if let resources = pokemon {
                await viewModel.getPokemonList(pokemon: resources)
            }
        }
        .background(Color.core.white)
    }
}

struct GridTileView: View {
    
    let pokemon: ListItemType
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text("#\(pokemon.id)")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.core.white)
                            
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 10)
                    .background(Color.core.green)
                    .cornerRadius(16)
                    .frame(height: 30)
                }
                
                VStack (alignment: .center) {
                    ImageView(withURL: pokemon.image)
                    Text(pokemon.name.capitalized)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.core.black)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 5)
        .padding(.bottom, 10)
        .aspectRatio(1, contentMode: .fit)
        .background(Color.core.white)
        .cornerRadius(16)
        .shadow(color: .core.grey.opacity(0.6),
                radius: 15,
                x:0,
                y:0)
        
    }
}

#Preview {
    PokemonListView(pokemon: [])
}
