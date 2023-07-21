//
//  RoomManagement.swift
//  개인_HotelManagement
//
//  Created by Jack Lee on 2023/07/21.
//

import Foundation

class RoomManager {
    private var selections: [Int: Int] = [1: 10_000, 2: 20_000, 3: 30_000, 4: 40_000, 5: 50_000]
    
    func showAvailableRooms() {
        for (rooms, price) in selections.sorted(by: <) {
            print("\(rooms)번 방 가격은 \(price)원 입니다.")
        }
    }
    
    func listAvailableRooms() -> Int {
        let rooms = selections.keys.count
        print("남은 방의 수는 \(rooms)입니다.")
        return rooms
    }
}
