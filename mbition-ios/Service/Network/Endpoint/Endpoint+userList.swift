//
//  Endpoint+userList.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension Endpoint where Kind == EndpointKinds.Public, Response == UserList.Model, Payload == String {
    static func userListWith(paginationRequest: Pagination.Sink<Response>.Request) -> Self {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "per_page", value: String(paginationRequest.perPage)))
        if paginationRequest.since > 0 {
            queryItems.append(URLQueryItem(name: "since", value: String(paginationRequest.since)))
        }
        return Endpoint(
            path: "users",
            queryItems: queryItems,
            paginationRequest: paginationRequest
        )
    }
}
