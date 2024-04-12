//
//  SplashView.swift
//  Pokemon
//
//  Created by Luke Taylor on 18/03/2024.
//

import SwiftUI
import SwiftyGif

struct SplashView: View {
    
    let imageNudge: CGFloat = 12
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.core.red.ignoresSafeArea()
                
                AnimatedGifView(name: "pikachu-running.gif")
                    .frame(width: 150, height: 150)
                    .position(x: proxy.size.width / 2,
                              y: proxy.size.height / 2 - self.imageNudge)
                
            }
        }
    }
}


#Preview {
    SplashView()
}
