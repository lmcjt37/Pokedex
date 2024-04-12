//
//  CustomSegmentView.swift
//  Pokedex
//
//  Created by Luke Taylor on 05/04/2024.
//

import SwiftUI

struct CustomSegmentView: View {
    
    let keyColor: Color
    
    @Binding var selectedOption: OptionTypes
    
    var SegmentationOptions: [OptionTypes] = [.About, .Status, .Moves]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(SegmentationOptions) { option in
                Button(action: {
                    selectedOption = option
                }, label: {
                    Text(option.rawValue)
                        .foregroundStyle(Color.core.black)
                })
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(selectedOption == option ? keyColor : .clear)
                .tint(.core.black)
            }
        }
        .background(Color.core.beige)
        .clipShape(Capsule())
        .padding(.top, 10)
    }
}

#Preview {
    @State var selectedOption = OptionTypes.About
    
    return VStack {
        CustomSegmentView(keyColor: .core.pink,
                          selectedOption: $selectedOption)
        
        switch selectedOption {
        case .About:
            Text("About")
                .foregroundStyle(Color.core.black)
        case .Status:
            Text("Status")
                .foregroundStyle(Color.core.black)
        case .Moves:
            Text("Moves")
                .foregroundStyle(Color.core.black)
        }
    }
}
