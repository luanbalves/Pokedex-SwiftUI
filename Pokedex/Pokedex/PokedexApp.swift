//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject private var router = AppRouter(dependencies: LiveDependencies())
    
    init() {
        URLProtocol.registerClass(PrintProtocol.self)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navigationPath) {
                router.view(for: .pokemon(.list))
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        router.view(for: route)
                    }
            }
            .environmentObject(router)
        }
    }
}
