//
//  RequestError.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import Foundation

enum RequestError: Error, Equatable {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decode: String(localized: "error.decode")
        case .invalidURL: String(localized: "error.invalidURL")
        case .noResponse: String(localized: "error.noResponse")
        case .unauthorized: String(localized: "error.unauthorized")
        case .unexpectedStatusCode: String(localized: "error.unexpectedStatusCode")
        case .unknown: String(localized: "error.unknown")
        }
    }
}
