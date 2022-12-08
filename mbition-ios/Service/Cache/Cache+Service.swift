//
//  Cache+Service.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import Foundation

// Define service protocol
protocol CacheService {
    associatedtype Key: Hashable
    associatedtype Value
    func insert(_ value: Value, forKey key: Key)
    func value(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func removeAll()
    subscript(key: Key) -> Value? { get set }
}

// Extend namespace
extension Cache { enum Service {} }

// Implement service
extension Cache.Service {
    struct Config {
        let memoryLimit: Int
        static let `default` = Config(memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    class InMemory<Key: Hashable, Value> {
        // MARK: - Init
        init(config: Config = Config.default, costProvider: @escaping (_ value: Value) -> Int) {
            self.config = config
            self.costProvider = costProvider
        }
        
        // MARK: - Private
        private let wrapped = NSCache<WrappedKey, Entry>()
        private let config: Config
        private let lock = NSLock()
        private let costProvider: (_ value: Value) -> Int
    }
}

// CacheService
extension Cache.Service.InMemory: CacheService {
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        lock.lock(); defer { lock.unlock() }
        wrapped.setObject(entry, forKey: WrappedKey(key), cost: costProvider(value))
    }
    
    func value(forKey key: Key) -> Value? {
        lock.lock(); defer { lock.unlock() }
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func remove(forKey key: Key) {
        lock.lock(); defer { lock.unlock() }
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    func removeAll() {
        lock.lock(); defer { lock.unlock() }
        wrapped.removeAllObjects()
    }
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                remove(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

// Define WrappedKey
extension Cache.Service.InMemory {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
}

// Define Entry
extension Cache.Service.InMemory {
    final class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}
