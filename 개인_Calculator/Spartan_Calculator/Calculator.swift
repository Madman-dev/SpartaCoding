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
    
    func subtract(_ firstNumber: Double, by secondNumber: Double) -> Double {
        let result = firstNumber - secondNumber
        return result
    }
    
    func add(_ firstNumber: Double, to secondNumber: Double) -> Double {
        let result = firstNumber + secondNumber
        return result
    }
    
    func divide(_ firstNumber: Double, by secondNumber: Double) -> Double {
        let result = firstNumber / secondNumber
        return result
    }

    func multiply(_ firstNumber: Double, by secondNumber: Double) -> Double {
        let result = firstNumber * secondNumber
        return result
    }
    
    func findRemainder(_ firstNumber: Int, with secondNumber: Int) -> Int {
        let result = firstNumber % secondNumber
        return result
    }
}

