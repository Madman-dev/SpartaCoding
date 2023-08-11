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
        Todo(id: 0, title: "여러분~", isCompleted: false, timeStamp: .now),
        Todo(id: 1, title: "여러분~~", isCompleted: false, timeStamp: .now),
        Todo(id: 2, title: "부~자 되세요~", isCompleted: false, timeStamp: .now),
        Todo(id: 3, title: "꼭이요~~~", isCompleted: false, timeStamp: .now),
        Todo(id: 4, title: "한국 광고", isCompleted: false, timeStamp: .now),
        Todo(id: 5, title: "한국 타이어", isCompleted: false, timeStamp: .now),
        Todo(id: 6, title: "탕수육", isCompleted: false, timeStamp: .now)
    ]
    static var completedList: [Todo] = []
    private let todoKey = "Todos"
    
    init() {
        loadTodos()
    }

    // 투두 List에서 완료 데이터만 추출 저장
    static func storeCompleted(todo: Todo) {
        guard todo.isCompleted == true else { return }
        completedList.append(todo)
    }
    
    // 투두 List에서 완료 여부 확인
    static func completeTodo(todo: Todo, isCompleted: Bool) {
        for index in 0..<list.count {
            if list[index].id == todo.id {
                list[index].isCompleted = isCompleted
            }
        }
        TodoManager.shared.saveTodos()
    }
    
    // Userdefault로 데이터 저장
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
    
    // Userdefault 저장 데이터 로드
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
