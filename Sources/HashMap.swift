//
//  HashMap.swift
//
//
//  Created by Peter Schuette on 9/11/24.
//

import Foundation

public struct HashMap<Key: Hashable, Comparable, Element> {
    private let rootCapacity: Int
    private var storage: ContiguousArray<Array<(Key, Element)>?>

    public init(expectedCapacity: Int = 100) {
        rootCapacity = expectedCapacity
        storage = ContiguousArray(repeating: nil, count: expectedCapacity)
    }
    
    public func get(valueFor key: Key) -> Element? {
        let index = key.hashValue % rootCapacity
        return storage[index]?.first(where: { $0.0 == key })?.1
    }
    
    @discardableResult
    mutating
    public func set(_ value: Element, for key: Key) -> Element? {
        let storageIndex = key.hashValue % rootCapacity
        var indexedStorage = storage[storageIndex] ?? Array<(Key, Element)>()
        defer {
            storage[storageIndex] = indexedStorage
        }
        if let existingIndex = indexedStorage.firstIndex(where: { $0.0 == key }) {
            let existing = indexedStorage[existingIndex].1
            indexedStorage[existingIndex] = (key, value)
            return existing
        } else {
            indexedStorage.append((key, value))
            return nil
        }
    }
    
    @discardableResult
    mutating
    public func remove(valueFor key: Key) -> Element? {
        let storageIndex = key.hashValue % rootCapacity
        guard 
            var indexedStorage = storage[storageIndex],
            let existingIndex = indexedStorage.firstIndex(where: { $0.0 == key })
        else { return nil }

        if indexedStorage.count == 1 {
            let stored = indexedStorage[existingIndex]
            storage[storageIndex] = nil
            return stored.1
        } else {
            return storage[storageIndex]?.remove(at: existingIndex).1
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

//extension HashMap: Equatable where Key: Equatable, Element: Equatable {}
//extension HashMap: Hashable where Element: Hashable { }
