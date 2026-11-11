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
        case .decode:
            "Não foi possível processar os dados recebidos."
        case .invalidURL:
            "Endereço inválido."
        case .noResponse:
            "O servidor não respondeu. Tente novamente."
        case .unauthorized:
            "Sessão expirada."
        case .unexpectedStatusCode:
            "Algo deu errado no servidor. Tente novamente."
        case .unknown:
            "Erro inesperado. Tente novamente."
        }
    }
}
