//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class TodoViewCell: UITableViewCell {
    
    var todo: Todo?
    
    func setTodo(_ setTodo: Todo) {
        todo = setTodo
        guard let todo else { return }
        
        if todo.isCompleted {
            textLabel?.text = nil
            textLabel?.attributedText = todo.title.strikeThrough()
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = todo.title
        }
    }
}
