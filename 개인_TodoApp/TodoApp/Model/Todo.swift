//
//  todoData.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/04.
//

import Foundation

struct Todo: Codable {
    var title: String
    var isCompleted: Bool = false
}
