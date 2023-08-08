//
//  TodoList.swift
//  TodoSample
//
//  Created by Jack Lee on 2023/08/08.
//

import Foundation

struct TodoList {
    static var list: [Todo] = [
        Todo(id: 0, title: "이것도", isCompleted: false),
        Todo(id: 1, title: "저장", isCompleted: false),
        Todo(id: 2, title: "가능한가요", isCompleted: false),
        Todo(id: 3, title: "선생님", isCompleted: false),
        Todo(id: 4, title: "진도가", isCompleted: false),
        Todo(id: 5, title: "너무빨라요", isCompleted: false),
    ]
    
    // todo를 입력받고 list안에서 찾아서 변경을 해준다...고하는데, 이 구성이 맞을까?
    static func completeTodo(todo: Todo, isCompleted: Bool) {
        for index in 0..<list.count {
            if list[index].id == todo.id {
                list[index].isCompleted = isCompleted
            }
        }
    }
    
    static func completeList() -> [Todo] {
        return list.filter { $0.isCompleted == true }
    }
}
