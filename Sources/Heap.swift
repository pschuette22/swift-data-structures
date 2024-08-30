//
//  Heap.swift
//
//
//  Created by Peter Schuette on 8/30/24.
//

import Foundation

public struct Heap<Element: Comparable> {
    public typealias Priority = (Element, Element) -> Bool

    // MARK: - Structure properties
    private var storage = [Element]()
    private let isPriority: Priority
    
    // MARK: - Computed helpers
    
    /// True if the heap contains no elements
    /// This is equal to *count == 0*
    public var isEmpty: Bool { storage.isEmpty }
    
    /// Number of elements in the Heap
    public var count: Int { storage.count }
    
    /// Element at the top of the heap
    /// This is nil when the heap is empty
    public var peek: Element? { storage[safe: 0] }
    
    
    /// Initialize a heap with priority determined by the caller
    /// If no priority function is called, implement a min heap
    /// - Parameters:
    ///   - initialValues: (optional) Array of values to enqueue to the heap
    ///   - isPriority: function determining which element has priority and should float upward
    public init(
        _ initialValues: [Element] = [Element](),
        priority isPriority: @escaping Priority = { $0 < $1 }
    ) {
        self.isPriority = isPriority
        initialValues.forEach { enqueue($0) }
    }
}

// MARK: - Named initializers
extension Heap {
    /// Initialize a heap where the __minimum__ value is kept at the top
    /// *O(n \* log(n)) runtime complexity where n = number of initial values
    /// - Parameter initialValues: (optional) Array of values to be enqueued onto the heap at start
    /// - Returns: ``Heap`` of elements where minimum value is kept at the top
    public static func minHeap(_ initialValues: [Element] = [Element]()) -> Heap<Element> {
        Heap(initialValues, priority: { $0 < $1 })
    }
    
    /// Initialize a heap where the __maximum__ value is kept at the top
    /// *O(n \* log(n)) runtime complexity where n = number of initial values
    /// - Parameter initialValues: (optional) Array of values to be enqueued onto the heap at start
    /// - Returns: ``Heap`` of elements where maximum value is kept at the top
    public static func maxHeap(_ initialValues: [Element] = [Element]()) -> Heap<Element> {
        Heap(initialValues, priority: { $0 > $1 })
    }
}

// MARK: - Child / Parent index helpers

extension Heap {
    private func parent(of index: Int) -> Int? {
        guard index > 0 else { return nil }
        
        return (index - 1) / 2
    }
    
    private func lhs(of index: Int) -> Int? {
        let lhs = (index * 2) + 1
        return lhs < count ? lhs : nil
    }
    
    private func rhs(of index: Int) -> Int? {
        let rhs = (index * 2) + 2
        return rhs < count ? rhs : nil
    }
}

// MARK: - Internal mutations

extension Heap {    
    mutating
    private func swap(_ lhs: Int, _ rhs: Int) {
        let swap = storage[rhs]
        storage[rhs] = storage[lhs]
        storage[lhs] = swap
    }

    mutating
    private func shiftUp(elementAt index: Int) {
        // shift the element up until it no longer has priority
        // If we're at the top, we're sifted up enough
        var index = index
        while 
            let parent = parent(of: index),
            isPriority(storage[index], storage[parent]) {
            swap(index, parent)
            index = parent
        }
    }
    
    mutating
    private func shiftDown(elementAt index: Int) {
        // Shift down while the index represents a lower priority than it's children
        // Swap with highest priority child
        var index = index
        while var priority = lhs(of: index).map({ isPriority(storage[index], storage[$0]) ? index : $0 }) {
            priority = rhs(of: index).map { isPriority(storage[priority], storage[$0]) ? priority : $0 } ?? priority
            if index == priority {
                break
            } else {
                swap(index, priority)
                index = priority
            }
        }
    }
}

// MARK: - Extenal interface

extension Heap {
    mutating
    public func enqueue(_ element: Element) {
        storage.append(element)
        shiftUp(elementAt: storage.count-1)
    }
    
    mutating
    public func dequeue() -> Element? {
        if count < 2 {
            // One or zero elements, return last if there is one
            return storage.popLast()
        }
        swap(0, count-1)
        let element = storage.removeLast()
        shiftDown(elementAt: 0)
        return element
    }
}
