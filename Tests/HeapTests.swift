//
//  HeapTests.swift
//
//
//  Created by Peter Schuette on 8/30/24.
//

import Foundation
import XCTest
@testable import DataStructures

final class HeapTests: XCTestCase {
    func test_minHeap_initializesAMinHeap() {
        var heap = Heap<Int>.minHeap([1,3,6,2,-1,7,-1,4,2])
        var ordered = [Int]()
        while let next = heap.pop() {
            ordered.append(next)
        }
        
        XCTAssertEqual(ordered, [-1,-1,1,2,2,3,4,6,7])
    }

    func test_maxHeap_initializesAMaxHeap() {
        var heap = Heap<Int>.maxHeap([1,3,6,2,-1,7,-1,4,2])
        var ordered = [Int]()
        while let next = heap.pop() {
            ordered.append(next)
        }
        
        XCTAssertEqual(ordered, [7,6,4,3,2,2,1,-1,-1])
    }

    func test_push_addsANewElement() {
        var heap = Heap<Int>()
        XCTAssert(heap.isEmpty)
        heap.push(1)
        XCTAssertEqual(heap.count, 1)
    }

    func test_push_whenNewElementHasPriority_addsElementToRoot() {
        var heap = Heap<Int>.minHeap()
        heap.push(all: [1,2,3])
        XCTAssertEqual(heap.peek, 1)
        heap.push(0)
        XCTAssertEqual(heap.peek, 0)
    }

    func test_pop_removesRootElement() {
        var heap = Heap<Int>.minHeap()
        heap.push(all: [1,2,3])
        XCTAssertEqual(heap.peek, 1)
        XCTAssertEqual(heap.pop(), 1)
        XCTAssertEqual(heap.peek, 2)
    }
}
