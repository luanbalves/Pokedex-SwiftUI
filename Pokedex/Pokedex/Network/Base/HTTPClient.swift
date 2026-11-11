//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import Foundation

protocol HTTPClient: Sendable {
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

/// Cliente HTTP padrão baseado em `URLSession`, com sessão injetável
/// para permitir testes com `URLProtocol` mockado.
struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw RequestError.invalidURL
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.noResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw RequestError.decode
            }
        case 401:
            throw RequestError.unauthorized
        default:
            throw RequestError.unexpectedStatusCode
        }
    }
}
