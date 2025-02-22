//
//  RequestError.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//


enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .invalidURL:
            return "INVALID URL"
        case .noResponse:
            return "No response"
        case .unexpectedStatusCode:
            return "500"
        default:
            return "Unknown error"
        }
    }
}