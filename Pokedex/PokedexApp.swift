//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Luke Taylor on 28/02/2024.
//

import SwiftUI

@main
struct PokedexApp: App {
    
    @State var isSplashLoading = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if self.isSplashLoading {
                    SplashView()
                } else {
                    SearchView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isSplashLoading = false
                }
            }
        }
    }
}
