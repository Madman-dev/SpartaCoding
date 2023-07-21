//
//  Calculator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class Calculator {
    private var firstNumber: Int
    private var secondNumber: Int
    
    init(firstNumber: Int, secondNumber: Int) {
        self.firstNumber = firstNumber
        self.secondNumber = secondNumber
    }
    
    enum Operation {
        case add
        case divide
        case multiply
        case subtract
    }
    
    
    func find(_ operation: Operation, _ firstNumber: Double, by secondNumber: Double) {
        
        switch operation {
        case .add:
            let result = AddOperator().calculate(firstNumber, by: secondNumber)
            print("결과 값은 \(result)입니다")
        case.divide:
            let result = DivisionOperator().calculate(firstNumber, by: secondNumber)
            print("결과 값은 \(result)입니다")
        case .multiply:
            let result = MultiplicationOperator().calculate(firstNumber, by: secondNumber)
            print("결과 값은 \(result)입니다")
        case .subtract:
            let result = SubtractOperator().calculate(firstNumber, by: secondNumber)
            print("결과 값은 \(result)입니다")
        }
    }
}
