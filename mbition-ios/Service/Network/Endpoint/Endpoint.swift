//
//  Endpoint.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

struct Endpoint<Kind: EndpointKind, Response: Codable, Payload: Encodable> {
    let method: Network.HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]?
    let payload: Payload?
    let paginationRequest: Pagination.Sink<Response>.Request?
    init(
        path: String,
        method: Network.HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        payload: Payload? = nil,
        paginationRequest: Pagination.Sink<Response>.Request? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.payload = payload
        self.paginationRequest = paginationRequest
    }
}

protocol EndpointKind {
    associatedtype RequestData
    static func prepare(_ request: inout URLRequest, with data: RequestData)
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
        }
    }
    
    enum Private: EndpointKind {
        static func prepare(_ request: inout URLRequest, with token: AccessToken) {
            request.addValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
        }
    }
}

extension Endpoint {
    func makeRequest(with data: Kind.RequestData?, host: URLHost = .default) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.rawValue
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let payload = payload, let payloadData = try? JSONEncoder().encode(payload) {
            request.httpBody = payloadData
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        if let data = data {
            Kind.prepare(&request, with: data)
        }
        return request
    }
}
