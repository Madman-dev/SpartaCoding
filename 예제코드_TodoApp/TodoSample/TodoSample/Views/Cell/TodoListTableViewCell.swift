//
//  TodoViewCell.swift
//  TodoSample
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var todoSwitch: UISwitch!
    
    var todo: Todo?
    
    // 🔥 Debugging할 때 오늘의 일을 참고 - 데이터가 있는지, 없는지 -> 저장 문제 or UI issue
    @IBAction func todoSwitchChanged(_ sender: UISwitch) {
        guard let todo else { return }
        if todoSwitch.isOn {
            // 이게 nil이 되는 이유는?
            textLabel?.text = nil
            textLabel?.attributedText = todo.title.strikeThrough()
            TodoList.completeTodo(todo: todo, isCompleted: true)
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = todo.title
            TodoList.completeTodo(todo: todo, isCompleted: false)
        }
    }
    
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
        todoSwitch.isOn = todo.isCompleted
    }
}


/// 문제 발생 가능성
// 1. clean
// 2. 연결 불안 (cell identifier)
// 3. delegate + dataSource 연결 안됨
