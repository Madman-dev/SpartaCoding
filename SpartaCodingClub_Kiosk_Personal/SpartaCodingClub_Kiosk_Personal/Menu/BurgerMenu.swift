//
//  BurgerMenu.swift
//  SpartaCodingClub_Kiosk_Personal
//
//  Created by Jack Lee on 2023/07/29.
//

import Foundation

struct BurgerMenu {
    // 버거 메뉴로 들어왔을 때 > 메뉴 출력
    private func displayMenu() {
        print("""
              1. ShackBurger   | W 6.9 | 토마토, 양상추, 쉑소수가 토핑된 치즈버거
              2. SmokeShack    | W 8.9 | 베이커, 체리 페퍼에 쉑 소스가 통핑된 치즈버거
              3. Shroom Burger | W 9.4 | 몬스터 치즈와 체다 치즈로 속을 채운 베지테리안 버거
              4. Cheese Burger | W 6.9 | 포테이토 번과 비프 패티, 치즈가 토핑된 치즈버거
              5. hamburger     | W 5.4 | 비프패티를 기반으로 야채가 들어간 기본 버거
              0. 뒤로가기        | 뒤로가기
              """)
    }
    
    // 메뉴 출력 이후, 값을 입력하면 관련 세부 정보를 보여줄 수 있는 기능 필요
    func read() -> Burger? {
        displayMenu()
        
        while true {
            let customerChoice = readLine()
            guard customerChoice == customerChoice else { print("입력이 되지 않았습니다. 다시 입력해주세요."); continue }
            var chosenBurger: Burger?
            
            switch customerChoice {
            case "1":
                chosenBurger = Burger(name: "ShackBurger", price: 6.9, description: "토마토, 양상추, 쉑소수가 토핑된 치즈버거")
            case "2":
                chosenBurger = Burger(name: "SmokeShack", price: 8.9, description: "베이커, 체리 페퍼에 쉑 소스가 통핑된 치즈버거")
            case "3":
                chosenBurger = Burger(name: "Shroom Burger", price: 9.4, description: "몬스터 치즈와 체다 치즈로 속을 채운 베지테리안 버거")
            case "4":
                chosenBurger = Burger(name: "Cheese Burger", price: 6.9, description: "포테이토 번과 비프 패티, 치즈가 토핑된 치즈버거")
            case "5":
                chosenBurger = Burger(name: "Hamburger", price: 5.4, description: "비프패티를 기반으로 야채가 들어간 기본 버거")
            case "0": // 0을 줬을 때 해당 loop에서 벗어날 수 있도록 해야하는데 그게 되고 있지 않다.
                return nil
            default:
                print("값이 입력되지 않았습니다.")
                continue    // continue는 어떤 역할을 하는걸까?
            }
        }
        print("햄버거가 만들어졌습니다.")
        
    }
}
