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
