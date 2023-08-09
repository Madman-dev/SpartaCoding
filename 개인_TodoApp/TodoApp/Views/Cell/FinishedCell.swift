//
//  FinishedCell.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/09.
//

import UIKit

class FinishedCell: UITableViewCell {
    var todo: Todo?
    
    func setTodo(_ setTodo: Todo) {
        todo = setTodo
        guard let todo else { return }
        textLabel?.text = todo.title
    }
}
