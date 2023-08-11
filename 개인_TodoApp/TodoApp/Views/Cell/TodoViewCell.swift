//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class TodoViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var todo: Todo?
    var todoIsComplete: Bool = false
    
    // 최초 cell을 세팅할 때 사용되는 기능
    func setTodo(_ setTodo: Todo) {
        todo = setTodo
        guard let todo else { return }
        
        if todo.isCompleted {
            textLabel?.text = nil
            textLabel?.attributedText = todo.title.strikeThrough()
            todoIsComplete = true
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = todo.title
        }
        todoIsComplete = todo.isCompleted
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        dateLabel.text = dateFormatter.string(from: todo.timeStamp)
    }
}
