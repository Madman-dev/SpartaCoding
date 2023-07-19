//
//  Calculator.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

class Calculator {
    var numbers: Int
    
    init(numbers: Int = 0) {
        self.numbers = numbers
    }
    
    func subtract(_ firstNumber: Int, by secondNumber: Int) {
        let result = firstNumber - secondNumber
        print("결과 값은 \(result)입니다.")
    }
    
    func add(_ firstNumber: Int, to secondNumber: Int) {
        let result = firstNumber + secondNumber
        print("결과 값은 \(result)입니다.")
    }
    
    func divide(_ firstNumber: Int, by secondNumber: Int) {
        let result = firstNumber / secondNumber
        print("결과 값은 \(result)입니다.")
    }

    func multiply(_ firstNumber: Int, by secondNumber: Int) {
        let result = firstNumber * secondNumber
        print("결과 값은 \(result)입니다.")
    }
}

