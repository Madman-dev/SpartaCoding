//
//  main.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

let calculator = Calculator(operation: AddOperator())
let addResult = calculator.calculate(firstNumber: 10, secondNumber: 20)

calculator.setOperation(operator: SubtractOperator())
let subtractResult = calculator.calculate(firstNumber: 20, secondNumber: 10)


calculator.setOperation(operator: MultiplicationOperator())
let multiplicationResult = calculator.calculate(firstNumber: 2, secondNumber: 4)

calculator.setOperation(operator: DivisionOperator())
let divisionResult = calculator.calculate(firstNumber: 10, secondNumber: 2)

print("더하기 결과값은 \(addResult)")
print("빼기 결과값은 \(subtractResult)")
print("곱하기 결과값은 \(multiplicationResult)")
print("나누기 결과값은 \(divisionResult)")
