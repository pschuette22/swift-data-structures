//
//  Operators.swift
//
//
//  Created by Peter Schuette on 9/2/24.
//

import Foundation

precedencegroup PowerPrecedence {
    higherThan: MultiplicationPrecedence
}

infix operator ^^: PowerPrecedence
public func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
