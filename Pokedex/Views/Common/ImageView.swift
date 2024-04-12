//
//  ImageView.swift
//  Pokedex
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI

struct ImageView: View {
    
    let urlString: String

    init(withURL urlString: String) {
        self.urlString = urlString
    }

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.core.lightGrey)
                .frame(maxWidth: 300)
        }
    }
}

#Preview {
    VStack {
        ImageView(withURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/26.png")
        
        ImageView(withURL: "")
    }
}
