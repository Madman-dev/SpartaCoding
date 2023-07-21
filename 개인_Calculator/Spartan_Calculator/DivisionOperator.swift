//
//  DivisionOperator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class DivisionOperator: AbstractOperator {
    func calculate(_ firstNumber: Double, by secondNumber: Double) -> Double {
        return firstNumber / secondNumber
    }
}
