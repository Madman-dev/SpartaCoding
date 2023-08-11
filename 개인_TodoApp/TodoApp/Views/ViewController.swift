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
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTodoButton()
        configureCheckFinished()
        
        /// 추가
        TodoManager.shared.loadTodos()
        /// 여기까지
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButton()
    }
    
//MARK: - UIComponent 구성 메서드
    private func configureTodoButton() {
        // 투두 버튼 생성
        addTodoButton.setTitle("할일 추가하기", for: .normal)
        addTodoButton.backgroundColor = .red
        addTodoButton.setTitleColor(.white, for: .normal)
        addTodoButton.layer.cornerRadius = 15
        addTodoButton.layer.borderWidth = 1
        addTodoButton.clipsToBounds = true
    }
    
    private func configureCheckFinished() {
        // 완료 확인 버튼 생성
        checkFinished.setTitle("완료한 일 확인하기", for: .normal)
        checkFinished.backgroundColor = .yellow
        checkFinished.setTitleColor(.black, for: .normal)
        checkFinished.layer.cornerRadius = 15
        checkFinished.layer.borderWidth = 1
        checkFinished.clipsToBounds = true
    }
    
    fileprivate func animateButton(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1) }
                           , completion: nil)
        }
    }
    
    //MARK: - UIAlertController 활용

    private func displayError(message: String) {
        let alert = UIAlertController(title: "10개 이상은 무리에요", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    private func addTodo() {
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
            
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let newTodo = Todo(id: (TodoManager.list.last?.id ?? -1) + 1, title: title, isCompleted: false)
                TodoManager.list.append(newTodo)
                self.todoTableView.insertRows(at: [IndexPath(row: TodoManager.list.count - 1, section: 0)], with: .automatic)
                /// 추가
                TodoManager.shared.saveTodos()
                /// 여기까지
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
        print("1차 출력~")
        return TodoManager.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        cell.setTodo(TodoManager.list[indexPath.row])
        print("2차 출력~")
        return cell
    }
    
    // 데이터를 바꾸는 메서드이기 때문에 여기에 존재, todoData를 변경하고 테이블 뷰에 있는 cell도 함께 지우는 중 -> 이후 TodoManager에서 최종 변경된 값을 저장
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 🔥 Keep actual data follow up with what's happening on screen - Needs to be lined up correctly
            // 🙋🏻‍♂️ 테이블 뷰에서 데이터 관리를 하는게 가장 복잡하던데, 기존에 가지고 있는 데이터에서 값을 먼저 삭제하고 테이블뷰에서 없애도록 처리를 하던데
            // 오히려 이게 에러를 발생시켜야하는 거 아닌가요?
            TodoManager.list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            /// 추가
//            TodoManager.shared.saveTodos()
            /// 여기까지
        }
    }
    
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
            
            var todo = TodoManager.list[indexPath.row]
            todo.isCompleted.toggle()
            TodoManager.list[indexPath.row] = todo
            
            // 셀을 확인해서 strikeThrough를 적용할지 확인
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
