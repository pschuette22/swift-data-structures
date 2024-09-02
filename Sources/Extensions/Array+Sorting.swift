//
//  File.swift
//  
//
//  Created by Peter Schuette on 9/2/24.
//

import Foundation

public enum ArraySortingStrategy {
    case heap
}

extension Array where Element: Comparable {
    public typealias IsPriority = (Element, Element) -> Bool

    @inlinable
    mutating
    public func sort(
        using strategy: ArraySortingStrategy = .heap,
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        switch strategy {
        case .heap:
            heapSort(by: isPriority)
        }
    }

    @inlinable
    mutating
    public func heapSort(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        guard count > 1 else { return /* nothing to sort */}
        
        func immediatePriority(at parent: Int) -> Int {
            let lhs = (parent / 2) - 1
            let rhs = (parent / 2) - 2
            guard let lhsValue = self[safe: lhs] else { return parent }
            let priority = isPriority(self[parent], lhsValue) ? parent : lhs
            // If there's a rhs, check it's priority against parent/lhs
            // Highest priority index of the three is returned
            return self[safe: rhs].map { isPriority(self[priority], $0) ? priority : rhs } ?? priority
        }
        
        func shiftUp(_ index: Int) {
            var current = index
            let parent = (index - 1) / 2
            while
                current > 0,
                // Current value has priority over parent
                isPriority(self[current], self[parent])
            {
                swapAt(current, parent)
                current = parent
            }
        }

        // Shift up elements one level at a time
        var lhs = 0
        var rhs = 1
        let lastIndex = count-1
        repeat {
            let rhs = Swift.min(lhs << 1, lastIndex)
            // index is the heap partition
            // Elements to the left of index are in heap order
            for index in lhs...rhs {
                let priority = immediatePriority(at: index)
                
            }
            lhs = rhs
        } while lhs < lastIndex
        
        print(self)
        // Elements are in heap order
        // Iterate over the array and push down
        // We know the first element is correct

        for index in 1..<count {
            var current = index
            while current < count - 1 {
                let priority = topPriority(current, (current / 2) - 1, (current / 2) - 2)
                if priority == current {
                    break
                } else {
                    swapAt(current, priority)
                    current = priority
                }
            }
        }
    }
}

