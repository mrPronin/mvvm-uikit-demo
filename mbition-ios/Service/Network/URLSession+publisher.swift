//
//  URLSession+publisher.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import Combine

extension URLSession {
    func publisherWith<Kind, Response, Payload>(
        paginationRequest: Pagination.Sink<Response>.Request,
        for endpoint: Endpoint<Kind, Response, Payload>,
        using requestData: Kind.RequestData? = nil,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Pagination.Sink<Response>.Response, Error> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: Network.Errors.invalidURL).eraseToAnyPublisher()
        }
        let nextSinceSubject = PassthroughSubject<Int?, Error>()
        return dataTaskPublisher(for: request)
            .tryMap({ [weak self] data, response in
                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw Network.error(from: response.statusCode)
                }
                
                let nextSince = self?.extractNextSince(from: (response as? HTTPURLResponse)?.allHeaderFields)
                nextSinceSubject.send(nextSince)
                // Return Response data
                return data
            })
            .decode(type: [Response].self, decoder: JSONDecoder())
            .withLatestFrom(nextSinceSubject)
            .map { Pagination.Sink<Response>.Response(data: $0.0, since: paginationRequest.since, nextSince: $0.1) }
            .mapError { Network.handleError($0) }
            .eraseToAnyPublisher()
    }
    
    func publisher<Kind, Response, Payload>(
        for endpoint: Endpoint<Kind, Response, Payload>,
        using requestData: Kind.RequestData? = nil,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Response, Error> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: Network.Errors.invalidURL).eraseToAnyPublisher()
        }
        return dataTaskPublisher(for: request)
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw Network.error(from: response.statusCode)
                }
                // debug
//                if let response = response as? HTTPURLResponse {
//                    LOG("allHeaderFields: \(response.allHeaderFields)")
//                }
                // debug
                // Return Response data
                return data
            })
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { Network.handleError($0) }
            .eraseToAnyPublisher()
    }
    
    func extractNextSince(from allHeaders: [AnyHashable : Any]?) -> Int? {
        guard let allHeaders = allHeaders else { return nil }
        guard let linkHeader = allHeaders["Link"] as? String else { return nil }
        guard let partWithSince = linkHeader.split(separator: ",").first(where: { $0.contains("since=") }) else { return nil }
        guard let regex = try? Regex("(http|https):\\/\\/([\\w_-]+(?:(?:\\.[\\w_-]+)+))([\\w.,@?^=%&:\\/~+#-]*[\\w@?^=%&\\/~+#-])") else { return nil }
        
        guard let urlMatch = partWithSince.firstMatch(of: regex) else { return nil }
        guard let urlComponents = URLComponents(string: String(urlMatch.0)) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        guard let sinceItemValue = queryItems.first(where: { $0.name == "since"})?.value else { return nil }
        guard let nextSince = Int(sinceItemValue) else { return nil }
        return nextSince
    }
}
