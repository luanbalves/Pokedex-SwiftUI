//
//  FavoritePokemon.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 11/11/26.
//

import SwiftData

@Model
final class FavoritePokemon {
    @Attribute(.unique) var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension FavoritePokemon {
    /// Reconstrói o `Pokemon` a partir do favorito salvo, permitindo exibi-lo
    /// mesmo que ele esteja numa página da lista que ainda não foi carregada.
    var pokemon: Pokemon {
        Pokemon(name: name, url: "https://pokeapi.co/api/v2/pokemon/\(id)/")
    }
}
