//
//  File.swift
//  
//
//  Created by Peter Schuette on 9/2/24.
//

import Foundation

public enum CollectionSortingStrategy {
    case heapSort
}

extension Collection where Element: Comparable {
    @inlinable
    mutating
    public func sort(
        using strategy: CollectionSortingStrategy = .heapSort,
        by isPriority: @escaping (Element, Element) -> Bool = { $0 < $1 }
    ) {
        switch strategy {
        case .heapSort:
            heapSort(by: isPriority)
        }
    }

    @inlinable
    mutating
    public func heapSort(by isPriority: @escaping (Element, Element) -> Bool) {
        guard count > 1 else { return }
        var indexHeap = Heap<Index>() { [self] in
            return self[$0] < self[$1]
        }

        var index = startIndex
        while index != endIndex {
            indexHeap.push(index)
            index = self.index(after: index)
        }
        
        while let index = indexHeap.pop() {
            
        }
        
    }
}

