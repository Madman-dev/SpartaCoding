//
//  main.swift
//  개인_HotelManagement
//
//  Created by Jack Lee on 2023/07/21.
//

import Foundation

private var menu: Array<String> = ["1, 2, 3, x"]
private var myCredit: Int = 0

while menu[0] != "x" {
    print("원하신 서비스를 입력해주세요.")
    print("1: 랜덤 방문 축하금 지급받기, 2: 방 금액 확인하기, x: 호텔 나가기")
    
    let userInput = readLine()
    let menuNumber = String(userInput!)
    if menuNumber == "x" { break }
    
    switch menuNumber {
    case "1":
        CreditManager().addCredit(to: myCredit)
        break
    case "2":
        print("\n방 가격은 아래와 같습니다!")
        RoomManager().showAvailableRooms()
        let userChoice = readLine()!
        
        if userChoice == String(RoomManager().listAvailableRooms()) {
            print("방으로 안내해 드리겠습니다.")
        }
        
    case "x":
        print("방문 해주셔서 감사드립니다. 종료하겠습니다.")
        break
    case "X":
        print("방문 해주셔서 감사드립니다. 종료하겠습니다.")
        break
    default:
        print("잘못 입려하셨습니다. 1~2 서비스를 선택하시거나 x로 종료해주세요.\n")
    }
}
