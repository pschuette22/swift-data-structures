//
//  Array+Extensions.swift
//
//
//  Created by Peter Schuette on 8/30/24.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        
        return self[index]
    }
}
