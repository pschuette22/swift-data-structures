//
//  File.swift
//  
//
//  Created by Peter Schuette on 9/2/24.
//

import Foundation

public enum ArraySortingStrategy: CaseIterable {
    case bubble
    case heap
    case merge
    case `default`
}

extension Array where Element: Comparable {
    public typealias IsPriority = (Element, Element) -> Bool

    @inlinable
    mutating
    public func sort(
        using strategy: ArraySortingStrategy,
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        switch strategy {
        case .bubble:
            bubbleSort(by: isPriority)
        case .heap:
            heapSort(by: isPriority)
        case .merge:
            mergeSort(by: isPriority)
        case .default:
            sort()
        }
    }

    @inlinable
    mutating
    public func heapSort(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        guard count > 1 else { return /* nothing to sort */}
        
        func shiftDown(_ n: Int, _ i: Int) {
            var largest = i
            let lhs = 2 * i + 1
            let rhs = 2 * i + 2

            if lhs < n && isPriority(self[largest], self[lhs]) {
                largest = lhs
            }

            if rhs < n && isPriority(self[largest], self[rhs]) {
                largest = rhs
            }

            if largest != i {
                swapAt(i, largest)
                shiftDown(n, largest)
            }
        }

        let n = count

        for i in stride(from: n / 2 - 1, through: 0, by: -1) {
            shiftDown(n, i)
        }

        for i in stride(from: n - 1, through: 1, by: -1) {
            swapAt(0, i)
            shiftDown(i, 0)
        }
    }

    @inlinable
    public func heapSorted(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) -> [Element] {
        var heap = Heap<Element>(priority: isPriority)
        heap.push(all: self)
        var result = [Element]()
        while let next = heap.pop() {
            result.append(next)
        }
        return result
    }

    @inlinable
    mutating
    public func mergeSort(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        guard count > 1 else { return /* nothing to sort */ }
        
        
        /// Moves the value at the right hand index to left hand index and shifts all values between to right
        /// - Parameters:
        ///   - rhs: upper index in array being shifted
        ///   - lhs: lower index in array being shifted
        func shiftValue(from rhs: Int, to lhs: Int) {
            let swap = self[rhs]
            for shiftIndex in stride(from: rhs, to: lhs, by: -1) {
                self[shiftIndex] = self[shiftIndex-1]
            }
            self[lhs] = swap
        }
        
        
        /// Recursive function for executing a merge sort in place
        /// - Parameters:
        ///   - lhs: start index within array to merge sort
        ///   - rhs: end index within array to merge sort
        func mergeSort(lhs: Int, rhs: Int) {
            guard lhs < rhs else { return }

            var mid = lhs + (rhs - lhs) / 2
            mergeSort(lhs: lhs, rhs: mid)
            mergeSort(lhs: mid+1, rhs: rhs)
        

            var index1 = lhs
            var index2 = mid + 1
            if isPriority(self[mid], self[index2]) { return }

            while index1 <= mid, index2 <= rhs {
                if isPriority(self[index1], self[index2]) {
                    index1 += 1
                } else {
                    shiftValue(from: index2, to: index1)
                    index1 += 1
                    mid += 1
                    index2 += 1
                }
            }
        }

        mergeSort(lhs: 0, rhs: count-1)
    }

    @inlinable
    public func mergeSorted(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) -> [Element]{         
        /// Recursive function for executing a merge sort in place
        /// - Parameters:
        ///   - lhs: start index within array to merge sort
        ///   - rhs: end index within array to merge sort
        func mergeSorted(lhs: Int, rhs: Int) -> [Element] {
            guard lhs < rhs else { return [self[lhs]] }

            let mid = lhs + (rhs - lhs) / 2
            var lhsSorted = mergeSorted(lhs: lhs, rhs: mid)
            var rhsSorted = mergeSorted(lhs: mid+1, rhs: rhs)


            if 
                let lhsLast = lhsSorted.last,
                let rhsFirst = rhsSorted.first,
                isPriority(lhsLast, rhsFirst) {
                    // Already in order
                    return lhsSorted + rhsSorted
            }

            var merged = [Element]()
            merged.reverse()
            while let lhsLast = lhsSorted.last, let rhsLast = rhsSorted.last {
                if isPriority(lhsLast, rhsLast) {
                    merged.append(rhsSorted.removeLast())
                } else {
                    merged.append(lhsSorted.removeLast())
                }
            }
            // Merge sorting is done in reverse to avoid swift array index shifting 
            return lhsSorted + rhsSorted + merged.reversed()
        }

        return mergeSorted(lhs: 0, rhs: count-1)
    }
    
    
    @inlinable
    mutating
    public func bubbleSort(
        by isPriority: @escaping IsPriority = { $0 < $1 }
    ) {
        for index in 1..<count {
            for swapIndex in stride(from: index, to: 0, by: -1) {
                if isPriority(self[swapIndex-1], self[swapIndex]) { continue }
                    
                swapAt(swapIndex, swapIndex-1)
            }
        }
    }
}

