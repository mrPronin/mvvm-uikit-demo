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

// Define request
extension Pagination.Sink {
    struct Request {
        let since: Int?
        let perPage: Int
        init(since: Int? = nil, perPage: Int = Pagination.perPage) {
            self.since = since
            self.perPage = perPage
        }
    }
}

// Define response
extension Pagination.Sink {
    struct Response: Codable {
        let data: [T]
        let since: Int?
    }
}

// Define LoadDataHandler type
extension Pagination.Sink {
    // loand new data with page number and page size limit
    typealias LoadDataHandler = (Request) -> AnyPublisher<Response, Error>
}

// Define Sink
extension Pagination {
    class Sink<T: Codable> {
        // MARK: - Public
        
        /// true if network loading is in progress.
        let activityIndicator: AnyPublisher<Bool, Never>
        
        /// elements from all loaded pages
        let elements: AnyPublisher<[T], Never>
        
        /// fires once for each error
        let error: AnyPublisher<Error, Never>
        
        let hasMore: AnyPublisher<Bool, Never>
        
        // MARK: - Privat
        @Published private var loadResults: [Int: [T]] = [:]
//        @Published private var error: Error?
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let wrappedElements = PassthroughSubject<[T], Never>()
        var subscriptions = Set<AnyCancellable>()

        // MARK: - Init
        init(ui: Pagination.UISource, loadData: @escaping LoadDataHandler) {
            activityIndicator = Empty().eraseToAnyPublisher()
            elements = wrappedElements.eraseToAnyPublisher()
            error = errorSubject.eraseToAnyPublisher()
            hasMore = Empty().eraseToAnyPublisher()

            // Load page
            let page = ui.reload
                .flatMap { loadData(.init()) }
                .catch { error -> AnyPublisher<Pagination.Sink.Response, Never> in
                    DispatchQueue.main.async { [weak self] in
                        self?.errorSubject.send(error)
                    }
                    return Empty().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
                .share()
            
            // Merge new page with existing pages
            page
                .map { (since: $0.since ?? 0, items: $0.data) }
                .withLatestFrom($loadResults)
                .map { [unowned self] in $0.0.since == 0 ? [0 : $0.0.items] : self.mergePages(newPage: [$0.0.since : $0.0.items], pages: $0.1) }
                .assign(to: &$loadResults)
            
            // Prepare items list
            $loadResults
                .map { $0.sorted(by: { $0.key < $1.key }).flatMap { $0.value } }
                .sink { [unowned self] in
                    self.wrappedElements.send($0)
                }
                .store(in: &subscriptions)
        }
        
        private func mergePages(newPage: [Int : [T]], pages: [Int : [T]]) -> [Int : [T]] {
            return pages.merging(newPage, uniquingKeysWith: { (_, new) in new })
        }
    }
}
