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
    static var list: [Todo] = [
        Todo(id: 0, title: "내가 오늘 할 일은", isCompleted: false, timeStamp: .now),
        Todo(id: 1, title: "밥먹기", isCompleted: false, timeStamp: .now),
        Todo(id: 2, title: "불금 즐기기", isCompleted: false, timeStamp: .now),
        Todo(id: 3, title: "밖에 나가서 커피 마시기", isCompleted: false, timeStamp: .now),
        Todo(id: 4, title: "친구들과 대화하기", isCompleted: false, timeStamp: .now),
        Todo(id: 5, title: "이것도?", isCompleted: false, timeStamp: .now),
        Todo(id: 6, title: "안되나?", isCompleted: false, timeStamp: .now)
    ]
    static var completedList: [Todo] = []
    private let todoKey = "Todos"
    
    init() {
        loadTodos()
    }

    static func storeCompleted(todo: Todo) {
        guard todo.isCompleted == true else { return }
        completedList.append(todo)
    }
    
    static func completeTodo(todo: Todo, isCompleted: Bool) {
        for index in 0..<list.count {
            if list[index].id == todo.id {
                list[index].isCompleted = isCompleted
            }
        }
        TodoManager.shared.saveTodos()
    }
    
    func saveTodos() {
        do {
            let listData = try JSONEncoder().encode(TodoManager.list)
            userDefaults.set(listData, forKey: todoKey)
            
            let completedListData = try JSONEncoder().encode(TodoManager.completedList)
            userDefaults.set(completedListData, forKey: "Completed" + todoKey)
            
            userDefaults.synchronize()
        } catch {
            print("Error saving todos: \(error)")
        }
    }
    
    func loadTodos() {
        if let listData = userDefaults.data(forKey: todoKey),
           let completedListData = userDefaults.data(forKey: "Completed" + todoKey) {
            let decoder = JSONDecoder()
            if let decodedList = try? decoder.decode([Todo].self, from: listData),
               let decodedCompletedList = try? decoder.decode([Todo].self, from: completedListData) {
                TodoManager.list = decodedList
                TodoManager.completedList = decodedCompletedList
            }
        }
    }
}
