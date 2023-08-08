//
//  TodoManager.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/07.
//

import Foundation

class TodoManager{
    static let shared = TodoManager()
    private let userDefaults = UserDefaults.standard
    private let todoKey = "Todos"
    static var list: [Todo] = [
        Todo(id: 0, title: "내가 오늘 할 일은", isCompleted: false),
        Todo(id: 1, title: "밥먹기", isCompleted: false),
        Todo(id: 2, title: "불금 즐기기", isCompleted: false),
        Todo(id: 3, title: "밖에 나가서 커피 마시기", isCompleted: false),
        Todo(id: 4, title: "친구들과 대화하기", isCompleted: false),
        Todo(id: 5, title: "이것도?", isCompleted: false),
        Todo(id: 6, title: "안되나?", isCompleted: true)
    ]
    
    static func completeTodo(todo: Todo, isCompleted: Bool) {
        for index in 0..<list.count {
            if list[index].id == todo.id {
                list[index].isCompleted = isCompleted
            }
        }
    }
    
    func saveTodo(_ items: [Todo]) {
        if let encodedData = try? JSONEncoder().encode(items) {
            userDefaults.set(encodedData, forKey: todoKey)
        }
    }
    
    func loadTodo() -> [Todo] {
        if let encodedData = userDefaults.data(forKey: todoKey),
           let decodedItems = try? JSONDecoder().decode([Todo].self, from: encodedData) {
            return decodedItems
        }
        return []
    }
}
