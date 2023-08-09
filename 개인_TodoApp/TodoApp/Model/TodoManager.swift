//
//  TodoManager.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/07.
//

import Foundation

class TodoManager{
    static let shared = TodoManager()
    /// 추가
    private let userDefaults = UserDefaults.standard
    /// 여기까지
    static var list: [Todo] = [
        Todo(id: 0, title: "내가 오늘 할 일은", isCompleted: false),
        Todo(id: 1, title: "밥먹기", isCompleted: false),
        Todo(id: 2, title: "불금 즐기기", isCompleted: false),
        Todo(id: 3, title: "밖에 나가서 커피 마시기", isCompleted: false),
        Todo(id: 4, title: "친구들과 대화하기", isCompleted: false),
        Todo(id: 5, title: "이것도?", isCompleted: false),
        Todo(id: 6, title: "안되나?", isCompleted: false)
    ]
    static var completedList: [Todo] = []
    /// 추가
    private let todoKey = "Todos"
    /// 여기까지
    
    /// 추가
    init() {
        loadTodos()
    }
    /// 여기까지
    
    // 완료된 데이터만 따로 저장하는 코드?
    static func storeCompleted(todo: Todo) {
        guard todo.isCompleted == true else { return }
        completedList.append(todo)
    }
    
    // 완료된 친구들은 완료, 미완은 미완으로 체크하는 코드
    static func completeTodo(todo: Todo, isCompleted: Bool) {
        for index in 0..<list.count {
            if list[index].id == todo.id {
                list[index].isCompleted = isCompleted
            }
        }
        /// 추가
        TodoManager.shared.saveTodos()
        /// 여기까지
    }
    
    /// 추가
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
    /// 여기까지
}
