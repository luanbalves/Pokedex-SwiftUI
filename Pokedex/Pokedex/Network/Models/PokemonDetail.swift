//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

struct PokemonDetail: Decodable, Identifiable {
    var id: Int
    var name: String
    var baseExperience: Int
    var height: Int
    var weight: Int
    var types: [PokemonTypes]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case types
    }
}

struct PokemonTypes: Decodable {
    var slot: Int
    var type: PokemonType
}

struct PokemonType: Decodable  {
    var name: String
    var url: String
}
