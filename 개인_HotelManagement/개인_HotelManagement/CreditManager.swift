//
//  GiveCredit.swift
//  개인_HotelManagement
//
//  Created by Jack Lee on 2023/07/21.
//

import Foundation

class CreditManager {
    private var credit: Int = 0
    
    func addCredit(to: Int) {
        let lowRange: Int = 100_000
        let highRange: Int = 500_000
        let countStep: Int = 10_000
        let randomCredit: Int = Int.random(in: lowRange...(highRange / countStep)) * countStep
        credit += randomCredit
    }
}
