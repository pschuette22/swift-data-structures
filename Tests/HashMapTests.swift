//
//  HashMapTests.swift
//
//
//  Created by Peter Schuette on 9/11/24.
//

import Foundation
import XCTest
@testable import DataStructures

final class HashMapTests: XCTestCase {
    func testInsert_addsAnElement() {
        var map = HashMap<String, Int>()
        XCTAssertEqual(map.count, 0)
        map.insert(1, for: "one")
        XCTAssertEqual(map.get(valueFor: "one"), 1)
    }
    
    func testInsert_overwritesExistingValue() {
        var map = HashMap<String, Int>()
        map.insert(1, for: "one")
        XCTAssertEqual(map.get(valueFor: "one"), 1)
        map.insert(2, for: "one")
        XCTAssertEqual(map.count, 1)
        XCTAssertEqual(map.get(valueFor: "one"), 2)
    }
    
    func testInsert_whenValueIsNil_removesValue() {
        var map = HashMap<String, Int>()
        map.insert(1, for: "one")
        XCTAssertEqual(map.get(valueFor: "one"), 1)
        map.insert(nil, for: "one")
        XCTAssertEqual(map.count, 0)
    }
    
    func testRemove_removesValue() {
        var map = HashMap<String, Int>()
        map.insert(1, for: "one")
        XCTAssertEqual(map["one"], 1)
        XCTAssertEqual(map.remove(valueFor: "one"), 1)
        XCTAssertEqual(map.count, 0)
    }
    
    func testRemove_whenKeyHashesOverlap_removesValue() {
        var map = HashMap<String, Int>(minimumCapacity: 1)
        map.insert(1, for: "one")
        map.insert(2, for: "two")
        XCTAssertEqual(map["one"], 1)
        XCTAssertEqual(map.remove(valueFor: "one"), 1)
        XCTAssertEqual(map.count, 1)
    }
    
    func testSubscript_retrievesValue_forKey() {
        var map = HashMap<String, Int>(minimumCapacity: 1)
        map.insert(1, for: "one")
        XCTAssertEqual(map["one"], 1)
    }
    
    func testSubscript_insertsValue_forKey() {
        var map = HashMap<String, Int>(minimumCapacity: 1)
        XCTAssertNil(map["one"])
        map["one"] = 1
        XCTAssertEqual(map["one"], 1)
    }
    
    func testSubscript_updatesValue_forKey() {
        var map = HashMap<String, Int>(minimumCapacity: 1)
        XCTAssertNil(map["one"])
        map["one"] = 1
        XCTAssertEqual(map["one"], 1)
        map["one"] = 2
        XCTAssertEqual(map["one"], 2)
    }
    
    func testIterator_iteratesOverEveryValue() {
        var map = HashMap<String, String>()
        map["one"] = "one"
        map["two"] = "two"
        map["three"] = "three"
        
        var iterator = map.makeIterator()
        var iterations = Set<String>()
        while let next = iterator.next() {
            XCTAssertEqual(next.0, next.1)
            iterations.insert(next.0)
        }
        XCTAssertEqual(iterations.count, 3)
        XCTAssertEqual(iterations, Set<String>(["one", "two", "three"]))
    }
}
