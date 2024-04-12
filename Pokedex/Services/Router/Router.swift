//
//  Router.swift
//  Pokedex
//
//  Created by Luke Taylor on 07/03/2024.
//

import SwiftUI

public final class Router: ObservableObject {
    @Published public var path = NavigationPath()

    public func navigate(to destination: any Hashable) {
        path.append(destination)
    }

    public func navigateBack() {
        path.removeLast()
    }

    public func navigateToRoot() {
        path.removeLast(path.count)
    }
}
