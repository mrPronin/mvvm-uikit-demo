//
//  ImageLoader+Service.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit
import Combine

// Define service protocol
protocol ImageLoaderService {
    static var shared: ImageLoaderService { get }
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

// Extend namespace
extension ImageLoader { enum Service {} }

// Implement service
extension ImageLoader.Service {
    class Implementation: ImageLoaderService {
        // MARK: - Public
        static let shared: ImageLoaderService = Implementation()
        
        func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
            if let image = cache[url] {
                return Just(image).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { (data, response) -> UIImage? in return UIImage(data: data) }
                .compactMap { $0 }
                .map { $0.decoded }
                .catch { error in return Just(nil) }
                .handleEvents(receiveOutput: {[unowned self] image in
                    guard let image = image else { return }
                    self.cache[url] = image
                })
//                .print("Image loading \(url):")
                .subscribe(on: backgroundQueue)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        // MARK: - Init
        init(cache: Cache.Service.InMemory<URL, UIImage> = .init(costProvider: UIImage.estimatedSize)) {
            self.cache = cache
        }
        
        // MARK: - Private
        private let cache: Cache.Service.InMemory<URL, UIImage>
        private lazy var backgroundQueue: OperationQueue = {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 5
            return queue
        }()
    }
}
