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
        while let next = heap.dequeue() {
            ordered.append(next)
        }
        
        XCTAssertEqual(ordered, [-1,-1,1,2,2,3,4,6,7])
    }
}
