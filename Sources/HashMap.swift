//
//  HashMap.swift
//
//
//  Created by Peter Schuette on 9/11/24.
//

import Foundation


/// Map Unique keys to arbitrary values
public struct HashMap<Key: Hashable & Comparable, Value> {
    typealias Storage = Array<Array<Node>?>
    
    struct Node {
        let key: Key
        let value: Value
    }

    /// Capacity of the storage array
    private let rootCapacity: Int
    /// Underlying storage
    private var storage: Array<Array<Node>?>

    /// Initialize the HashMap
    /// - Parameter expectedCapacity: Higher capcaity creates a larger minimum storage footprint
    public init(minimumCapacity: Int = 100) {
        rootCapacity = minimumCapacity
        storage = Array(repeating: nil, count: minimumCapacity)
    }

    /// Number of elements in the HashMap
    public var count: Int {
        storage.reduce(into: 0) { result, indexedStorage in
            result += indexedStorage?.count ?? 0
        }
    }

    /// Retrieve a value for a key. Nil if one does not exist
    /// - Parameter key: Unique key for storing and retrieving a value
    /// - Returns: Value mapped to key, if present
    public func get(valueFor key: Key) -> Value? {
        let index = key.hashValue % rootCapacity
        return storage[index]?.first(where: { $0.key == key })?.value
    }

    /// Update the value for a key
    /// If the key already has a mapped value, overwrite and return the replaced value
    /// If the provided value is nil, remove the existing mapping
    /// - Parameters:
    ///   - value: (optional) value to map to a key
    ///   - key: unique identifier for the value
    /// - Returns: Value that was replaced or nil
    @discardableResult mutating public func set(
        _ value: Value?,
        for key: Key
    ) -> Value? {
        guard let value else {
            return remove(valueFor: key)
        }

        let storageIndex = key.hashValue % rootCapacity
        var indexedStorage = storage[storageIndex] ?? Array<Node>()
        defer {
            storage[storageIndex] = indexedStorage
        }
        if let existingIndex = indexedStorage.firstIndex(where: { $0.key == key }) {
            let existing = indexedStorage[existingIndex].value
            indexedStorage[existingIndex] = Node(key: key, value: value)
            return existing
        } else {
            indexedStorage.append(Node(key: key, value: value))
            return nil
        }
    }

    /// Remove the value for a key.
    /// - Parameter key: unique identifier of value that should be removed
    /// - Returns: value that was removed or nil if none was found
    @discardableResult mutating public func remove(
        valueFor key: Key
    ) -> Value? {
        let storageIndex = key.hashValue % rootCapacity
        guard 
            var indexedStorage = storage[storageIndex],
            let existingIndex = indexedStorage.firstIndex(where: { $0.key == key })
        else { return nil }

        if indexedStorage.count == 1 {
            let stored = indexedStorage[existingIndex]
            storage[storageIndex] = nil
            return stored.value
        } else {
            return storage[storageIndex]?.remove(at: existingIndex).value
        }
    }

    public subscript(_ key: Key) -> Value? {
        get {
            get(valueFor: key)
        }
        set {
            set(newValue, for: key)
        }
    }
}

// MARK: - HashMap + Sequence

extension HashMap: Sequence {
    public typealias Element = (Key, Value)
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = (Key, Value)
        
        var iteratorIndex = 0
        var innerIterator: Array<Node>.Iterator?
        var storage: Storage
        
        init(_ storage: Storage) {
            self.storage = storage
        }
        

        mutating
        public func next() -> Element? {
            if let next = innerIterator?.next() {
                return (next.key, next.value)
            }

            repeat {
                // Find the next
                iteratorIndex += 1
            } while iteratorIndex < storage.count && storage[iteratorIndex] == nil

            guard iteratorIndex < storage.count else { return nil }
            
            innerIterator = storage[iteratorIndex]?.makeIterator()
            return innerIterator?.next().map { ($0.key, $0.value) }
        }
    }

    /// Make an iterator to iterate over all key / value pairs
    /// - Returns: Iterates over 
    public func makeIterator() -> Iterator {
        Iterator(storage)
    }
}

// MARK: - HashMap + Equatable

extension HashMap.Node: Equatable where Value: Equatable { }
extension HashMap: Equatable where Value: Equatable { }

// MARK: - HashMap + Hashable

extension HashMap.Node: Hashable where Value: Hashable { }
extension HashMap: Hashable where Value: Hashable { }
