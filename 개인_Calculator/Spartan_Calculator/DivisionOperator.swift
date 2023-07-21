//
//  DivisionOperator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class DivisionOperator: AbstractOperator {
    override func operate(_ firstNumber: Int, by secondNumber: Int) -> Double {
        return Double(firstNumber / secondNumber)
    }
}
