//
//  SearchInputView.swift
//  Pokemon
//
//  Created by Luke Taylor on 21/03/2024.
//

import SwiftUI

struct SearchInputView: View {
    
    @Binding var searchItem: String
    var submitAction: (() async -> Void)?
    var changeAction: (() async -> Void)?
    
    var body: some View {
        HStack {
            if (searchItem.isEmpty) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.core.grey)
            }
            TextField("",
                      text: $searchItem,
                      prompt: Text("Search").foregroundStyle(Color.core.grey))
                .onSubmit {
                    Task {
                        if let submitAction {
                            await submitAction()
                        }
                    }
                }
                .onChange(of: searchItem) {
                    Task {
                        if let changeAction {
                            await changeAction()
                        }
                    }
                }
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .submitLabel(.go)
            
        }
        .padding()
        .background(.white)
        .foregroundStyle(Color.core.black)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.core.grey, lineWidth: 2))
    }
}

#Preview {
    ZStack {
        Color.core.lightGrey.ignoresSafeArea()
        
        SearchInputView(searchItem: .constant(""))
            .padding()
    }
}
