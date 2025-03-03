//
//  AppRouter.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 28/02/25.
//

import SwiftUI

protocol AppRouting: ObservableObject {
    associatedtype Route: Hashable
    var navigationPath: NavigationPath { get set }
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

final class AppRouter: AppRouting {
    enum Route: Hashable {
        case pokemon(PokemonRoute)
    }
    
    @Published var navigationPath = NavigationPath()
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    func navigate(to route: Route) {
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .pokemon(let subRoute):
            PokemonFeatureRouter.view(for: subRoute, router: self)
        }
    }
}
