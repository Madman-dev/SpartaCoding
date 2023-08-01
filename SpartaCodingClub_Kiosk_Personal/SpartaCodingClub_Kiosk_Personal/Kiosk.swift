//
//  Kiosk.swift
//  SpartaCodingClub_Kiosk_Personal
//
//  Created by Jack Lee on 2023/07/29.
//

import Foundation

class Kiosk {
    private var greeting: String = """
                        안녕하세요, Out Of This World 버거를 제공하는 OOTB입니다!
                        아래 메뉴판을 보시고 메뉴를 골라 입력해주세요.
                        """
    private var menuIntro: String = """
                            [OOTB Burger Menu]
                            1. Burgers          | 오늘의 비프 통살이 꽉 들어간 버거
                            2. Frozen Custard   | 매니저가 직접 짠 신선한 우유로 만든 아이스크림
                            3. Drinks           | 버거에 탄산은 빼놓을 수 없죠
                            4. Beer             | 비프와 찰떡궁합인 보리 음료!
                            0. 뒤로가기           | 프로그램을 종료합니다.
                            """
    
    enum Menu: String {
        case burger     = "1"
        case custard    = "2"
        case drink      = "3"
        case beer       = "4"
        case cancel     = "0"
    }
    
    func run() {
        greetCustomer()
        sleep(1)
        displayMenu()
        
        // loop로 꺼지지 않도록 구현
        while true {
            let input = readLine()!
            guard input == input else { return }
            
            switch input {
                // 🙋🏻‍♂️ 여기 문제점은 해당 함수들은 print만 하는 친구들이고 실질적으로 값을 주고 받거나 혹은 더 내부적으로 들어가는 모습이 아니다.
            case "1": BurgerMenu().read()
            default:
                print("종료합니다.")
                break
            }
        }
    }
    
    private func greetCustomer() {
        print(greeting)
    }
    
    private func displayMenu() {
        print(menuIntro)
    }
}


