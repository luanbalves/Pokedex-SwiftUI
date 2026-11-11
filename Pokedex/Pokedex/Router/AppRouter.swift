//
//  AppRouter.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 28/02/25.
//

import SwiftUI

@MainActor
@Observable
final class AppRouter {
    enum Route: Hashable {
        case pokemon(PokemonRoute)
    }

    var navigationPath = NavigationPath()
    private let dependencies: AppDependencies

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
        navigationPath = NavigationPath()
    }

    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .pokemon(let subRoute):
            PokemonFeatureRouter.view(for: subRoute, dependencies: dependencies)
        }
    }
}
