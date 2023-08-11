//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class ViewController: UIViewController {

//MARK: - Outlet 및 전역 변수 정리
    @IBOutlet weak var checkFinished: UIButton!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTodoButton()
        configureCheckFinished()
        
        // Userdefault 데이터 호출
        TodoManager.shared.loadTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButton()
    }
    
//MARK: - UIComponent 구성 메서드
    
    private func configureTodoButton() {
        addTodoButton.setTitle("할일 추가하기", for: .normal)
        addTodoButton.backgroundColor = .red
        addTodoButton.setTitleColor(.white, for: .normal)
        addTodoButton.layer.cornerRadius = 15
        addTodoButton.layer.borderWidth = 1
        addTodoButton.clipsToBounds = true
    }
    
    private func configureCheckFinished() {
        checkFinished.setTitle("완료한 일 확인하기", for: .normal)
        checkFinished.backgroundColor = .yellow
        checkFinished.setTitleColor(.black, for: .normal)
        checkFinished.layer.cornerRadius = 15
        checkFinished.layer.borderWidth = 1
        checkFinished.clipsToBounds = true
    }
    
    // 버튼 bounceBack 효과
    fileprivate func animateButton(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1) }
                           , completion: nil)
        }
    }
    
    
    //MARK: - 에러 대처
    private func displayErrors(for errorType: Errors) {
        let alert: UIAlertController
        
        switch errorType {
        case .blankTextField:
            alert = UIAlertController(title: "내용이 비어있어요!",
                                      message: "투두 작성을 잊으신거 아니실까요?",
                                      preferredStyle: .alert)
        case .tooMuchTodos:
            alert = UIAlertController(title: "10개 이상은 집중하기 힘들지 않을까요?",
                                      message: "맨 위 목표 먼저 마무리해 주세요",
                                      preferredStyle: .alert)
        }
        
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    private func addTodo() {
        let alert = UIAlertController(title: "오늘의 Todo",
                                      message: "무엇을 하고 싶으세요?",
                                      preferredStyle: .alert)
        
        if TodoManager.list.count >= 10 {
            displayErrors(for: .tooMuchTodos)
            return
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "마음껏 작성하세요!"
        }
        
        let saveTodo = UIAlertAction(title: "저장하기", style: .default) { [weak self] action in
            guard let self = self else { return }
           
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let newTodo = Todo(id: (TodoManager.list.last?.id ?? -1) + 1, title: title, isCompleted: false)
                TodoManager.list.append(newTodo)
                self.todoTableView.insertRows(at: [IndexPath(row: TodoManager.list.count - 1, section: 0)], with: .automatic)
                
                // Userdefault에 데이터 저장
                TodoManager.shared.saveTodos()
            } else {
                displayErrors(for: .blankTextField)
            }
        }
        
        let cancel = UIAlertAction(title: "뒤로 돌아가기", style: .cancel, handler: nil)
        alert.addAction(saveTodo)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    //MARK: - 버튼 사이즈 조절
    
    fileprivate func updateButton() {
        let totalButtonWidth: CGFloat = view.bounds.width - 32

        let minButtonWidth: CGFloat = 0
        let maxButtonWidth = totalButtonWidth
        
        let numberOfTodos = CGFloat(TodoManager.list.count)
        
        // 투두에 맞춰서 최대 크기를 조절한다
        var newButtonAWidth = max(minButtonWidth, maxButtonWidth - numberOfTodos * 100)
        // 최대 크기에서 늘어난 버튼 크기를 조절한다
        var newButtonBWidth = maxButtonWidth - newButtonAWidth
        
        
//        if newButtonAWidth > maxButtonWidth {
//            let temp = newButtonAWidth
//            newButtonAWidth = newButtonBWidth
//            newButtonBWidth = temp
//        }
        
        UIView.animate(withDuration: 0.3) {
            self.addTodoButton.frame.size.width = newButtonAWidth
            self.checkFinished.frame.size.width = newButtonBWidth
        }
    }
    
    @IBAction func checkFinishedTapped(_ sender: UIButton) {
        animateButton(sender)
    }
    
    
    @IBAction func addTodoTapped(_ sender: UIButton) {
        self.animateButton(sender)
        addTodo()
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        cell.setTodo(TodoManager.list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoManager.list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            // Userdefault에 데이터 저장
            TodoManager.shared.saveTodos()
        }
    }
    
    // 선택한 cell 자동 deselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] action, view, complete in
            guard let self = self else {
                complete(false)
                return
            }
            
            // Todo에 완료 여부(strikeThrough) 확인 및 처리
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
      
            if todo.isCompleted {
                TodoManager.storeCompleted(todo: todo)
                TodoManager.list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            complete(true)
            print("완료했습니다.")
        }
        let actions = UISwipeActionsConfiguration(actions: [complete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}
