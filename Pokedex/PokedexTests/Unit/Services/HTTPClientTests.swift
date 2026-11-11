//
//  HTTPClientTests.swift
//  PokedexTests
//
//  Created by Luan Alves Barroso on 11/03/25.
//

import Foundation
import Testing
@testable import Pokedex

/// Testes reais do cliente HTTP, com `URLProtocol` mockado.
/// (Os testes antigos testavam o próprio mock — aqui cobrimos o código de verdade.)
@Suite(.serialized)
struct HTTPClientTests {
    private struct Stub: Decodable, Equatable {
        let name: String
    }

    private struct StubEndpoint: Endpoint {
        var path: String { "/stub" }
        var method: RequestMethod { .get }
    }

    private func makeClient() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSessionHTTPClient(session: URLSession(configuration: configuration))
    }

    private func makeResponse(_ statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://pokeapi.co/stub")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    @Test func decodesSuccessfulResponse() async throws {
        MockURLProtocol.requestHandler = { _ in
            (self.makeResponse(200), Data(#"{"name":"pikachu"}"#.utf8))
        }

        let result: Stub = try await makeClient().send(StubEndpoint())

        #expect(result == Stub(name: "pikachu"))
    }

    @Test func throwsDecodeOnInvalidJSON() async {
        MockURLProtocol.requestHandler = { _ in
            (self.makeResponse(200), Data("not json".utf8))
        }

        do {
            let _: Stub = try await makeClient().send(StubEndpoint())
            Issue.record("Deveria lançar RequestError.decode")
        } catch {
            #expect(error as? RequestError == .decode)
        }
    }

    @Test func throwsUnauthorizedOn401() async {
        MockURLProtocol.requestHandler = { _ in
            (self.makeResponse(401), Data())
        }

        do {
            let _: Stub = try await makeClient().send(StubEndpoint())
            Issue.record("Deveria lançar RequestError.unauthorized")
        } catch {
            #expect(error as? RequestError == .unauthorized)
        }
    }

    @Test func throwsUnexpectedStatusCodeOn500() async {
        MockURLProtocol.requestHandler = { _ in
            (self.makeResponse(500), Data())
        }

        do {
            let _: Stub = try await makeClient().send(StubEndpoint())
            Issue.record("Deveria lançar RequestError.unexpectedStatusCode")
        } catch {
            #expect(error as? RequestError == .unexpectedStatusCode)
        }
    }
}
