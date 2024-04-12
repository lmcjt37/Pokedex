//
//  Color.swift
//  Pokemon
//
//  Created by Luke Taylor on 01/03/2024.
//

import SwiftUI

extension Color {
    
    init(red: Int, green: Int, blue: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: opacity
        )
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            print("Could not fetch color components for \(self)")
            return (0, 0, 0, 0)
        }
        
        return (r, g, b, o)
    }
    
    func luminance() -> Double {
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * adjust(colorComponent: self.components.red) + 0.7152 * adjust(colorComponent: self.components.green) + 0.0722 * adjust(colorComponent: self.components.blue)
    }
    
    struct core {
        static let red = Color(red: 255, green: 87, blue: 86)
        static let green = Color(red: 142, green: 219, blue: 138)
        static let orange = Color(red: 255, green: 173, blue: 118)
        static let blue = Color(red: 146, green: 185, blue: 247)
        static let white = Color(red: 249, green: 249, blue: 249)
        static let black = Color(red: 49, green: 47, blue: 47)
        static let grey = Color(red: 177, green: 177, blue: 177)
        static let lightGrey = Color(red: 235, green: 234, blue: 235)
        static let beige = Color(red: 247, green: 236, blue: 213)
        static let yellow = Color(red: 254, green: 222, blue: 116)
        static let pink = Color(red: 255, green: 151, blue: 180)
        static let coral = Color(red: 243, green: 121, blue: 117)
    }
    
    struct types {
        static let normal = Color(red: 162, green: 163, blue: 160)
        static let fire = Color(red: 255, green: 173, blue: 118)
        static let fighting = Color(red: 243, green: 121, blue: 117)
        static let water = Color(red: 146, green: 185, blue: 247)
        static let flying = Color(red: 208, green: 186, blue: 248)
        static let grass = Color(red: 142, green: 219, blue: 138)
        static let poison = Color(red: 213, green: 131, blue: 197)
        static let electric = Color(red: 255, green: 217, blue: 88)
        static let ground = Color(red: 239, green: 200, blue: 112)
        static let psychic = Color(red: 255, green: 151, blue: 180)
        static let rock = Color(red: 218, green: 194, blue: 126)
        static let ice = Color(red: 174, green: 232, blue: 232)
        static let bug = Color(red: 196, green: 211, blue: 104)
        static let dragon = Color(red: 174, green: 124, blue: 252)
        static let ghost = Color(red: 169, green: 149, blue: 190)
        static let dark = Color(red: 167, green: 145, blue: 135)
        static let steel = Color(red: 34, green: 149, blue: 165)
        static let fairy = Color(red: 255, green: 177, blue: 192)
        static let shadow = Color(red: 171, green: 135, blue: 220)
    }
    
}
