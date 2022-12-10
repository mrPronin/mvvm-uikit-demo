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
    }
}

// Define request
extension Pagination.Sink {
    struct Request {
        let since: Int
        let perPage: Int
        init(since: Int, perPage: Int = Pagination.perPage) {
            self.since = since
            self.perPage = perPage
        }
    }
}

// Define response
extension Pagination.Sink {
    struct Response: Codable {
        let data: [T]
        let since: Int
        let nextSince: Int?
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
        let activityIndicator: AnyPublisher<Bool, Never>
        let elements: AnyPublisher<[T], Never>
        let error: AnyPublisher<Error, Never>
//        let hasMore: AnyPublisher<Bool, Never>
        
        // MARK: - Privat
        @Published var pages: [Int: [T]] = [:]
        @Published var nextSince: Int = 0
        @Published var hasMore: Bool = true
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let wrappedElements = PassthroughSubject<[T], Never>()
        private var subscriptions = Set<AnyCancellable>()

        // MARK: - Init
        init(ui: Pagination.UISource, loadData: @escaping LoadDataHandler) {
            activityIndicator = Empty().eraseToAnyPublisher()
            elements = wrappedElements.eraseToAnyPublisher()
            error = errorSubject.eraseToAnyPublisher()

            let reloadStream = ui.reload
                .share()
            
            // Reload from first page, reset $nextSince to 0
            reloadStream
                .map { 0 }
                .assign(to: &$nextSince)
            
            // Reset hasMore
            reloadStream
                .map { true }
                .assign(to: &$hasMore)
            
            // Prevent request if we are reached the end of data
            let loadNextPageStream = ui.loadNextPage
                .withLatestFrom($hasMore)
                .filter { $1 }
                .map { _ in Void() }
            
            // Merge load next and reload streams
            let startStream = loadNextPageStream
                .merge(with: reloadStream)
                .share()
            
            // Load data for page with nextSince
            let pageStream = startStream
                .withLatestFrom($nextSince)
                .flatMap { loadData(.init(since: $1)) }
                .catch { error -> AnyPublisher<Pagination.Sink.Response, Never> in
                    DispatchQueue.main.async { [weak self] in
                        self?.errorSubject.send(error)
                    }
                    return Empty().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
                .share()
            
            // Update next since from response
            pageStream
                .map(\.nextSince)
                .compactMap { $0 }
                .assign(to: &$nextSince)
            
            // Update hasMore from response
            pageStream
                .map(\.data)
                .map { $0.isEmpty }
                .filter { $0 }
                .map { !$0 }
                .assign(to: &$hasMore)
            
            // Merge new page with existing pages
            pageStream
                .map { (since: $0.since, items: $0.data) }
                .withLatestFrom($pages)
                .map { [unowned self] in $0.0.since == 0 ? [0 : $0.0.items] : self.mergePages(newPage: [$0.0.since : $0.0.items], pages: $0.1) }
                .assign(to: &$pages)
            
            // Prepare items list
            $pages
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
