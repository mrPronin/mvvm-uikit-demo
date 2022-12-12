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
    struct Response {
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
        
        // MARK: - Privat
        @Published var pages: [Int: [T]] = [:]
        @Published var nextSince: Int = 0
        @Published var hasMore: Bool = true
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let elementsSubject = PassthroughSubject<[T], Never>()
        private let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
        private let startSubject = PassthroughSubject<Void, Never>()
        private var subscriptions = Set<AnyCancellable>()

        // MARK: - Init
        init(ui: Pagination.UISource, loadData: @escaping LoadDataHandler) {
            activityIndicator = activityIndicatorSubject.eraseToAnyPublisher()
            elements = elementsSubject.eraseToAnyPublisher()
            error = errorSubject.eraseToAnyPublisher()

            ui.reload
                .sink(receiveValue: { [unowned self] in
                    self.nextSince = 0
                    self.hasMore = true
                    self.startSubject.send()
                })
                .store(in: &subscriptions)
            
            // Prevent request if we are reached the end of data
            ui.loadNextPage
                .withLatestFrom($hasMore)
                .filter { $1 }
                .sink(receiveValue: { [unowned self] _ in
                    self.startSubject.send()
                })
                .store(in: &subscriptions)
            
            // Load data for page with nextSince
            let pageStream = startSubject
                .handleEvents(receiveOutput: { [unowned self] _ in
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicatorSubject.send(true)
                    }
                })
                .withLatestFrom($nextSince)
                .flatMap { loadData(.init(since: $1)) }
                .handleEvents(receiveOutput: { [unowned self] _ in
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicatorSubject.send(false)
                    }
                })
                .catch { error -> AnyPublisher<Pagination.Sink.Response, Never> in
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicatorSubject.send(false)
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
                    self.elementsSubject.send($0)
                }
                .store(in: &subscriptions)
        }
        
        private func mergePages(newPage: [Int : [T]], pages: [Int : [T]]) -> [Int : [T]] {
            return pages.merging(newPage, uniquingKeysWith: { (_, new) in new })
        }
    }
}
