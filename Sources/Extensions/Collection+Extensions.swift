//
//  Collection+Extensions.swift
//
//
//  Created by Peter Schuette on 8/30/24.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        
        return self[index]
    }
}
