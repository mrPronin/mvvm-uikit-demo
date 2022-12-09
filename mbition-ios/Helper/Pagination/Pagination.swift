//
//  Pagination.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 09.12.22.
//

import Foundation
import Combine

enum Pagination {}

// Define page size
extension Pagination {
    static let perPage: Int = 20
}

// Define UISource
extension Pagination {
    struct UISource {
        /// reloads first page and dumps all other cached pages.
        let reload: AnyPublisher<Void, Never>
        /// loads next page
        let loadNextPage: AnyPublisher<Void, Never>
        let subscriptions: Set<AnyCancellable>
    }
}

// Define Sink
extension Pagination {
    struct Sink<T: Codable> {
        // loand new data with page number and page size limit
        typealias LoadDataHandler = (Request) -> AnyPublisher<Response, Never>
        /// true if network loading is in progress.
        let activityIndicator: AnyPublisher<Bool, Never>
        /// elements from all loaded pages
        let elements: AnyPublisher<[T], Never>
        /// fires once for each error
        let error: AnyPublisher<Error, Never>
        
        let hasMore: AnyPublisher<Bool, Never>
    }
}

// Define request
extension Pagination.Sink {
    struct Request {
        let since: Int?
        let perPage: Int
    }
}

// Define response
extension Pagination.Sink {
    struct Response: Codable {
        let data: [T]
        let since: Int?
    }
}

// Define Sing init
extension Pagination.Sink {
    init(ui: Pagination.UISource, loadData: @escaping LoadDataHandler) {
        
        activityIndicator = Empty().eraseToAnyPublisher()
        elements = Empty().eraseToAnyPublisher()
        error = Empty().eraseToAnyPublisher()
        hasMore = Empty().eraseToAnyPublisher()
    }
}
