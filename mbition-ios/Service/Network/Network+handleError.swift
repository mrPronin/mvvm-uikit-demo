//
//  Network+handleError.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension Network {
    enum Errors: LocalizedError {
        case invalidURL
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case error4xx(_ code: Int)
        case serverError
        case error5xx(_ code: Int)
        case decodingError
        case urlSessionFailed(_ error: URLError)
        case unknownError(_ code: Int)
        case other(error: Error)
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
        default: return .unknownError(statusCode)
        }
    }
    static func handleError(_ error: Error) -> Network.Errors {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as Network.Errors:
            return error
        default:
            return .other(error: error)
        }
    }
}

// MARK: - LocalizedError
extension Network.Errors {
    public var errorDescription: String? {
        switch self {
            // "Network error. Invalid URL."
            // "Netzwerkfehler. Ungültige URL."
        case .invalidURL: return "Network error. Invalid URL."
            // "Network error. Bad request."
            // "Netzwerkfehler. Ungültige Anfrage."
        case .badRequest: return "Network error. Bad request."
            // "Network error. Unauthorized."
            // "Netzwerkfehler. Nicht autorisiert."
        case .unauthorized: return "Network error. Unauthorized."
            // "Network error. Forbidden."
            // "Netzwerkfehler. Verboten."
        case .forbidden: return "Network error. Forbidden."
            // "Network error. Link not found."
            // "Netzwerkfehler. Link nicht gefunden."
        case .notFound: return "Network error. Link not found."
            // "Network error \(code)"
            // "Netzwerkfehler \(code)"
        case .error4xx(let code): return "Network error \(code)"
            // "Network error. Server exception."
            // "Netzwerkfehler. Serverfehler."
        case .serverError: return "Network error. Server exception."
            // "Network error \(code)"
            // "Netzwerkfehler \(code)"
        case .error5xx(let code): return "Network error \(code)"
            // "Network error. Decoding failed."
            // "Netzwerkfehler. Decodierung fehlgeschlagen."
        case .decodingError: return "Network error. Decoding failed."
            // "Network error. URL session failed with \(error)"
            // "Netzwerkfehler. URL-Sitzung fehlgeschlagen mit \(error)"
        case .urlSessionFailed(let error): return "Network error. URL session failed with error! \(error.localizedDescription)"
            // "Network error. Unknown."
            // "Netzwerkfehler. Unbekannt."
        case .unknownError: return "Network error. Unknown."
            // "Network error. Other: \(error.localizedDescription)"
            // "Netzwerkfehler. Andere: \(error.localizedDescription)"
        case .other(error: let error):
            return "Network error. Other: \(error.localizedDescription)"
        }
    }
}
