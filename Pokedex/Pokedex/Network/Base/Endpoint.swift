//
//  Endpoint.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//


import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "pokeapi.co"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil 
    }
}
