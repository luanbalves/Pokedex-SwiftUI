//
//  PokemonEndpoint.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import Foundation

enum PokemonEndpoint {
    case getAllPokemons(offset: Int?, limit: Int?)
}

extension PokemonEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .getAllPokemons:
            return "/api/v2/pokemon/"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getAllPokemons:
            .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getAllPokemons:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllPokemons(let offset, let limit):
            if let offset = offset {
                return [URLQueryItem(name: "offset", value: String(offset))]
            }
            
            if let limit = limit {
                return [URLQueryItem(name: "limit", value: String(limit))]
            }
            
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllPokemons:
            return nil
        }
    }
}
