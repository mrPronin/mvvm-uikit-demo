//
//  Network+handleError.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension Network {
    enum Errors: LocalizedError, Equatable {
        case invalidEndpoint
        case invalidRequest
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case error4xx(_ code: Int)
        case serverError
        case error5xx(_ code: Int)
        case decodingError
        case urlSessionFailed(_ error: URLError)
        case unknownError
    }
    
    static func error(from statusCode: Int) -> Errors {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    static func handleError(_ error: Error) -> Errors {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as Network.Errors:
            return error
        default:
            return .unknownError
        }
    }
}

