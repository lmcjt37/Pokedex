//
//  LoadingView.swift
//  Pokemon
//
//  Created by Luke Taylor on 09/03/2024.
//

import SwiftUI
import SwiftyGif

struct LoadingView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack{}
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.white.opacity(0.2))
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 3)
                    
                VStack {
                    Text("Loading...")
                        .foregroundStyle(Color.core.black)
                    AnimatedGifView(name: "pikachu-running.gif")
                        .frame(width: 100, height: 100)
                    
                }
            }
            .background(Color.core.white)
        }
    }
}

#Preview {
    LoadingView()
}
