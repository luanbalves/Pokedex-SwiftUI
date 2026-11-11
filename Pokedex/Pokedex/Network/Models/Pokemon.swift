//
//  Pokemon.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

struct Pokemon: Decodable, Identifiable, Hashable {
    let name: String
    let url: String

    /// O ID é derivado da URL do recurso (ex.: ".../pokemon/25/" → 25),
    /// evitando IDs opcionais ou duplicados na lista.
    var id: Int {
        Self.id(from: url) ?? 0
    }

    static func id(from url: String) -> Int? {
        guard let idString = url.split(separator: "/").last else { return nil }
        return Int(idString)
    }
}

struct PokemonsResponse: Decodable {
    let count: Int
    let results: [Pokemon]
}
