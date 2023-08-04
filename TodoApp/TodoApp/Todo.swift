//
//  todoData.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/04.
//

import Foundation

struct Todo {
    var title: String
    var isCompleted: Bool = false
//    var date: Date?
    
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}
