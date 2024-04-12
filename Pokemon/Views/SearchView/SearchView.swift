//
//  SearchView.swift
//  Pokemon
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI
import PokemonAPI

enum SearchViews: Hashable {
    case TypeView
    case LocationsView
    case MovesView
    case FavouritesView
    case Error(message: String)
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { geometry in
                ZStack {
                    Color.core.red.ignoresSafeArea()
                    
                    Circle()
                        .fill(.white)
                        .scaleEffect(2.2)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.width * 2.2)
                    
                    VStack {
                        TitleView(geometry: geometry)
                        
                        SearchableView(geometry: geometry)
                        
                        Spacer()
                        
                        VStack (spacing: 10) {
                            ButtonView(title: "Types", 
                                       icon: nil,
                                       image: "pokeball",
                                       color: .core.green,
                                       action: {
                                router.navigate(to: SearchViews.TypeView)
                            })
                            ButtonView(title: "Locations", 
                                       icon: "map.fill",
                                       image: nil,
                                       color: .core.orange,
                                       action: {
                                router.navigate(to: SearchViews.LocationsView)
                            })
                            ButtonView(title: "Moves and Abilities", 
                                       icon: "star.fill",
                                       image: nil,
                                       color: .core.blue,
                                       action: {
                                router.navigate(to: SearchViews.MovesView)
                            })
                            ButtonView(title: "Favourites", 
                                       icon: "heart.fill",
                                       image: nil,
                                       color: .core.red,
                                       action: {
                                router.navigate(to: SearchViews.FavouritesView)
                            })
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .navigationDestination(for: SearchViews.self) { view in
                            switch (view) {
                            case .MovesView, .LocationsView, .FavouritesView:
                                PokemonListView(pokemon: [])
                            case .TypeView:
                                TypeListView()
                            case .Error(let message):
                                Text(message)
                                    .foregroundStyle(Color.core.black)
                            }
                        }
                    }
                    .navigationDestination(for: ListItemType.self) { pokemon in
                        DetailTabView(pokemon: pokemon)
                    }
                }
            }
        }
        .environmentObject(router)
        .tint(Color.core.black)
        .background(Color.core.white)
    }
}

struct ButtonView: View {
    
    let title: String
    let icon: String?
    let image: String?
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                Spacer()
                if (icon != nil) {
                    Image(systemName: icon!)
                } else if (image != nil) {
                    Image(image!)
                        .resizable()
                        .frame(width:22, height: 22)
                }
                
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            .foregroundStyle(Color.core.white)
            .background(color)
            .cornerRadius(25)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .shadow(color: .core.grey,
                radius:5,
                x:0,
                y:3)
    }
}

struct TitleView: View {
    
    let geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Image("pokeball")
                .resizable()
                .frame(width:40, height:40)
                .fontWeight(.bold)
                .rotationEffect(.degrees(-45))
            
            Text("Pokedex")
                .foregroundStyle(Color.core.white)
                .font(.system(size: 40))
                .padding(.leading, 20)
            
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: geometry.size.width, alignment: .leading)
    }
}

struct SearchableView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var router: Router
    @State var searchItem = ""
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        ZStack {
            Image("pokeball")
                .resizable()
                .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                .fontWeight(.bold)
                .rotationEffect(.degrees(-45))
                .foregroundStyle(.white)
                .opacity(0.1)
            
            VStack {
                Text("Who's that pokemon?")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.core.white)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                
                SearchInputView(searchItem: $searchItem, 
                                submitAction: {
                    Task {
                        if (!searchItem.isEmpty) {
                            // TODO: Result handling otherwise error throws
                            await viewModel.fetchPokomon(searchItem)
                            
                            router.navigate(to: viewModel.pokemon!)
                            
                        }
                    }
                })
                .padding()
            }
        }
    }
}

#Preview {
    SearchView()
}
