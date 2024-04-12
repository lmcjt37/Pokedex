//
//  ThreeDotIndicator.swift
//  Pokedex
//
//  Created by Luke Taylor on 01/04/2024.
//

import SwiftUI

struct Fancy3DotsIndexView: View {
  
    // MARK: - Public Properties
    
    let numberOfPages: Int
    let currentIndex: Int
    let primaryColor: Color?
    let secondaryColor: Color?
    
    // MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 16
    private let circleSpacing: CGFloat = 12
    private let smallScale: CGFloat = 0.6
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? primaryColor ?? Color.core.grey : secondaryColor ?? Color.core.grey.opacity(0.6))
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                    
                        .frame(width: circleSize, height: circleSize)
                    
                        .transition(AnyTransition.opacity.combined(with: .scale))
                    
                        .id(index)
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}
