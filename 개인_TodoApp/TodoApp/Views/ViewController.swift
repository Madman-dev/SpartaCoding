//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

//MARK: - 이슈 정리
/*
 1. 데이터 저장이 안된다.
 2. 지울 때 효과가 없다. < DONE
 3. 어느 시점에 지워야하는지 모른다.
 currentTitle을 처리하지 않았다 - nil값, 런타임에 꺼진다. > 해결! UIViewController
 
 - 데이터가 다음으로 안넘어간다
 - 완료 버튼을 누르면 표기가 되지 않는다.
 - 지울 때 효과가 없다.

 
 🔥🔥🔥 데이터는 한 쪽에서 관리를 하는게 좋은 것 같다. 각 뷰컨트롤러에서 변수를 지정해서 저장을 진행하는 방식보다 좀 더 편리한 듯?
*/



class ViewController: UIViewController {
//MARK: - Outlet 및 전역 변수 정리
    @IBOutlet weak var checkFinished: UIButton!
    @IBOutlet weak var addTodo: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    var completedData: [Todo] = [] // no data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTodoButton()
        configureCheckFinished()
    }
    
//MARK: - UIComponent 구성 메서드
    func configureTodoButton() {
        // 투두 버튼 생성
        addTodo.setTitle("할일 추가하기", for: .normal)
        addTodo.backgroundColor = .black
        addTodo.setTitleColor(.white, for: .normal)
        addTodo.layer.cornerRadius = 15
        addTodo.layer.borderWidth = 1
        addTodo.clipsToBounds = true
    }
    
    func configureCheckFinished() {
        // 완료 확인 버튼 생성
        checkFinished.setTitle("완료한 일 확인하기", for: .normal)
        checkFinished.backgroundColor = .yellow
        checkFinished.setTitleColor(.black, for: .normal)
        checkFinished.layer.cornerRadius = 15
        checkFinished.layer.borderWidth = 1
        checkFinished.clipsToBounds = true
    }
    
    //MARK: - UIAlertController 활용

    func displayError(message: String) {
        let alert = UIAlertController(title: "10개 이상은 무리에요", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    @IBAction func addTodoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "오늘의 Todo", message: "무엇을 하고 싶으세요?", preferredStyle: .alert)
        
        if TodoManager.list.count >= 10 {
            displayError(message: "맨 위 목표 먼저 마무리해 주세요!")
            return
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "마음껏 작성하세요!"
        }
        
        let saveTodo = UIAlertAction(title: "저장하기", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            // 이부분 체크 필요
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let newTodo = Todo(id: (TodoManager.list.last?.id ?? -1) + 1, title: title, isCompleted: false)
                TodoManager.list.append(newTodo)
                self.todoTableView.insertRows(at: [IndexPath(row: TodoManager.list.count - 1, section: 0)], with: .automatic)
            }
        }
        
        let cancel = UIAlertAction(title: "뒤로 돌아가기", style: .cancel, handler: nil)
        alert.addAction(saveTodo)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        cell.setTodo(TodoManager.list[indexPath.row])
        return cell
    }
    
    // 데이터를 바꾸는 메서드이기 때문에 여기에 존재, todoData를 변경하고 테이블 뷰에 있는 cell도 함께 지우는 중 -> 이후 TodoManager에서 최종 변경된 값을 저장
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 🔥 Keep actual data follow up with what's happening on screen - Needs to be lined up correctly
            TodoManager.list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        // userdefault에 저장이 되고 있지 않음
//        TodoManager.shared.saveTodo(TodoManager.list)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] action, view, complete in
            guard let self = self else {
                complete(false)
                return
            }
            
            var todo = TodoManager.list[indexPath.row]
            todo.isCompleted.toggle()
            TodoManager.list[indexPath.row] = todo
            
            if let cell = tableView.cellForRow(at: indexPath) as? TodoViewCell {
                if todo.isCompleted {
                    cell.textLabel?.attributedText = todo.title.strikeThrough()
                    TodoManager.completeTodo(todo: todo, isCompleted: true)
                } else {
                    cell.textLabel?.attributedText = nil
                    cell.textLabel?.text = todo.title
                    TodoManager.completeTodo(todo: todo, isCompleted: false)
                }
            }
            complete(true)
            print("완료했습니다.")
        }
        let actions = UISwipeActionsConfiguration(actions: [complete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}

