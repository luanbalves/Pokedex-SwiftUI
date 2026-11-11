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
