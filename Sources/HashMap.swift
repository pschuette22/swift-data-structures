//
//  HashMap.swift
//
//
//  Created by Peter Schuette on 9/11/24.
//

import Foundation

public struct HashMap<Key: Hashable & Comparable, Element> {
    private let rootCapacity: Int
    private var storage: Array<Array<Node>?>
    struct Node {
        let key: Key
        let value: Element
    }

    public init(expectedCapacity: Int = 100) {
        rootCapacity = expectedCapacity
        storage = Array(repeating: nil, count: expectedCapacity)
    }
    
    public var count: Int {
        storage.reduce(into: 0) { result, indexedStorage in
            result += indexedStorage?.count ?? 0
        }
    }
    
    public func get(valueFor key: Key) -> Element? {
        let index = key.hashValue % rootCapacity
        return storage[index]?.first(where: { $0.key == key })?.value
    }
    
    @discardableResult
    mutating
    public func set(_ value: Element, for key: Key) -> Element? {
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
    
    @discardableResult
    mutating
    public func remove(valueFor key: Key) -> Element? {
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
    
    public subscript(_ key: Key) -> Element? {
        get {
            get(valueFor: key)
        }
        set {
            if let newValue {
                set(newValue, for: key)
            } else {
                remove(valueFor: key)
            }
        }
    }
}

extension HashMap.Node: Equatable where Element: Equatable { }
extension HashMap.Node: Hashable where Element: Hashable { }
extension HashMap: Equatable where Element: Equatable { }
extension HashMap: Hashable where Element: Hashable { }
