//
//  File.swift
//  
//
//  Created by Peter Schuette on 9/2/24.
//

import Foundation
import XCTest
@testable import DataStructures

final class Array_SortingTests: XCTestCase {
    func test_bubbleSort_sortsElement() {
        var array = [0,1,2,3,4,5,6,7,8].shuffled()
        array.bubbleSort()
        XCTAssertEqual(array, [0,1,2,3,4,5,6,7,8])
    }
    
    func test_heapSort_sortsElements() {
        var array = [0,1,2,3,4,5,6,7,8].shuffled()
        array.heapSort()
        XCTAssertEqual(array, [0,1,2,3,4,5,6,7,8])
    }
    
    func test_mergeSort_sortsElement() {
        var array = [0,1,2,3,4,5,6,7,8].shuffled()
        array.mergeSort()
        XCTAssertEqual(array, [0,1,2,3,4,5,6,7,8])
    }
}
