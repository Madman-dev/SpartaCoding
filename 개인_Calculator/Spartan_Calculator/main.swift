//
//  main.swift
//  Spartan_Calculator
//
//  Created by Jack Lee on 2023/07/19.
//

import Foundation

// 객체 생성
let calculator = Calculator()

// 결과 담기 && 출력
let addedResult = calculator.add(4, to: 8)
print("더하기 결과값은 \(addedResult)입니다.")

let subtractResult = calculator.subtract(17, by: 3)
print("빼기 결과값은 \(subtractResult)입니다.")

let divisionResult = calculator.divide(31, by: 2)
print("나누기 결과값은 \(divisionResult)입니다.")

let multiplicationResult = calculator.multiply(20, by: 3)
print("곱하기 결과값은 \(multiplicationResult)입니다.")

let remainderResult = calculator.findRemainder(7, with: 2)
print("나머지의 결과값은 \(remainderResult)입니다.")
