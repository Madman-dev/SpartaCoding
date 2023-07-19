//
//  Calculator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class Calculator {
    init() {
    }
    
    // Lower possibilities of typo
    enum Operator {
        case add
        case subtract
        case multiply
        case divide
    }
    
    // calculate values according to operations
    // 이렇게 너무 많은 행동을 담고 있으면 깔끔하지 않은 것으로 알고 있는데... 리팩토링 방법 고민해보자
    func find(_ operation: Operator, _ firstNumber: Double, by secondNumber: Double) {
        switch operation {
        case .add:
            let result = AddOperator().add(firstNumber, to: secondNumber)
            print("더하기 결과값은 \(result)입니다.")
        case.divide:
            let result = DivisionOperator().divide(firstNumber, by: secondNumber)
            print("나누기 결과값은 \(result)입니다.")
        case .multiply:
            let result = MultiplicationOperator().multiply(firstNumber, by: secondNumber)
            print("곱하기 결과값은 \(result)입니다.")
        case .subtract:
            let result = SubtractOperator().subtract(firstNumber, by: secondNumber)
            print("빼기 결과값은 \(result)입니다.")
        }
    }
    
    // 🙋🏻‍♂️ Why did they leave this guy out?
    func findRemainder(_ firstNumber: Int, with secondNumber: Int) {
        let result = firstNumber % secondNumber
        print("\(firstNumber) 나누기 \(secondNumber)의 나머지는 \(result)입니다.")
    }
}
