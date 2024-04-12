//
//  TypeListViewModel.swift
//  Pokedex
//
//  Created by Luke Taylor on 07/03/2024.
//

import Foundation
import SwiftUI

@MainActor
class TypeListViewModel: ObservableObject {
       
    @Published var types: [ClassType] = []
    @Published var typesList: [ClassType] = []
    @Published var hasError = false
    @Published var isLoading = false
    @Published var isLoaded = false 
    @Published var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())]
    @Published var searchItem = ""

    func getTypeList() async {
        guard !isLoaded else { return }
        
        isLoading = true
        do {
            self.types = try await PkmnService().fetchAllTypes()
            self.typesList = self.types
            hasError = false
            isLoading = false
            isLoaded = true
        } catch (let error) {
            self.types = []
            self.typesList = []
            self.hasError = true
            isLoading = false
            print(error.localizedDescription)
        }
    }
    
    func handleOnChangeEvent() {
        if (searchItem.isEmpty) {
            self.types = typesList
            return
        }
        self.types = typesList.filter { $0.type.name.lowercased().contains(searchItem.lowercased()) }
    }
}
