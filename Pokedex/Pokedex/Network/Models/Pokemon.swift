//
//  Pokemon.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

struct Pokemon: Decodable, Identifiable {
    var id: Int?
    let name: String
    let url: String
}

struct PokemonsResponse: Decodable {
    let count: Int
    let results: [Pokemon]
}
