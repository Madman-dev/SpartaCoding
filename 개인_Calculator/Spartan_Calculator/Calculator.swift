//
//  Calculator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class Calculator {
    private var abstractOperator: AbstractOperator
    
    enum Operation {
        case add
        case divide
        case multiply
        case subtract
    }
    
    init(operation: AbstractOperator) {
        self.abstractOperator = operation
    }
    
    func setOperation(operator: AbstractOperator) {
    self.abstractOperator = `operator`
    }
    
    func calculate(firstNumber: Int, secondNumber: Int) -> Double {
        abstractOperator.operate(firstNumber, by: secondNumber) ?? 0
    }
}
