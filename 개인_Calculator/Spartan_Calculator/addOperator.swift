//
//  addOperator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class AddOperator: AbstractOperator {
    override func operate(_ firstNumber: Int, by secondNumber: Int) -> Double {
        return Double(firstNumber + secondNumber)
    }
}
