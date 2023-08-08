//
//  CompletedCell.swift
//  TodoSample
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class CompletedViewCell: UITableViewCell {
    var todo: Todo?
    
    func setTodo(_ setTodo: Todo) {
        todo = setTodo
        guard let todo else { return }
        textLabel?.text = todo.title
    }
}
