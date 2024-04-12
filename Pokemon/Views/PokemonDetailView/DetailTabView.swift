//
//  DetailTabView.swift
//  Pokemon
//
//  Created by Luke Taylor on 24/03/2024.
//

import SwiftUI

struct DetailTabView: View {
    
    @StateObject var viewModel = DetailViewModel()
    
    @State var selectedTab = 0
    
    let pokemon: ListItemType
    
    var body: some View {
        Group {
            if viewModel.pokemon != nil, let vmPokemon = viewModel.pokemon {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        TabView(selection: $selectedTab) {
                            DetailView(pokemon: vmPokemon,
                                       moveSet: viewModel.moveSet,
                                       keyColor: viewModel.keyColor,
                                       isFavourited: $viewModel.isFavourited)
                                .tag(0)
                                .toolbar(.hidden, for: .tabBar)
                                .toolbarBackground(.hidden, for: .tabBar)
                            
                            EvolutionsView(pokemon: vmPokemon,
                                           evolutions: vmPokemon.evolutions,
                                           keyColor: viewModel.keyColor,
                                           isFavourited: $viewModel.isFavourited)
                                .tag(1)
                                .toolbar(.hidden, for: .tabBar)
                                .toolbarBackground(.hidden, for: .tabBar)
                            
                            LocationsView(pokemon: vmPokemon,
                                          locations: [],
                                          keyColor: viewModel.keyColor,
                                          isFavourited: $viewModel.isFavourited)
                                .tag(2)
                                .toolbar(.hidden, for: .tabBar)
                                .toolbarBackground(.hidden, for: .tabBar)
                        }
                        
                        ZStack {
                            HStack(spacing: geometry.size.width / 5) {
                                ForEach((TabbedItem.allCases), id: \.self){ item in
                                    Button {
                                        selectedTab = item.rawValue
                                    } label: {
                                        CustomTabItem(tab: item,
                                                      isActive: (selectedTab == item.rawValue))
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width)
                        .padding(.bottom, 25)
                        .padding(.top, 10)
                        .background(Color.core.white)
                        .cornerRadius(50)
                        .shadow(color: .core.grey,
                                radius: 15,
                                x: 0,
                                y: 10)
                    }
                }
            } else {
                LoadingView()
            }
        }
        .task {
            await viewModel.fetchPokemon(pokemon.name)
        }
        .ignoresSafeArea()
    }
}

struct CustomTabItem: View {
    
    let tab: TabbedItem
    let isActive: Bool
    
    var body: some View {
        HStack {
            if (tab.rawValue == 0) {
                Image( tab.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isActive ? .core.black : .core.grey)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: isActive ? tab.iconName + ".fill" : tab.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isActive ? .core.black : .core.grey)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

enum TabbedItem: Int, CaseIterable {
    case detail = 0
    case evolutions
    case locations
    
    var title: String {
        switch self {
        case .detail:
            return "Detail"
        case .evolutions:
            return "Evolutions"
        case .locations:
            return "Locations"
        }
    }
    
    var iconName: String {
        switch self {
        case .detail:
            return "pikachu-face"
        case .evolutions:
            return "fossil.shell"
        case .locations:
            return "map"
        }
    }
}

#Preview {
    DetailTabView(pokemon:
                        ListItemType(id: 12,
                                     name: "butterfree",
                                     image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/12.png",
                                     resourceUrl: "https://pokeapi.co/api/v2/pokemon/12/"))
}
