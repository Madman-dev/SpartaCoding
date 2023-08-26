//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

//MARK: - 요청사항 정리
/*
 필수 구현
 ㄴ userdefault로 데이터 유지 - CRUD (지금은 무엇이 가능한가? > 🔥create, 🔥read, update, 🔥delete > 제대로 되는건 create, read인거 같은데?
 ㄴ ⭐️ tableView section/ header / footer로 구분 - 카테고리별로 구분 짓기 >> inset group으로 정리를 하고 cell에서 섹션을 정리할 수 있을까?
 ㄴ 이미지 url을 활용해서 데이터 호출하기 -> 이건 투두의 디테일을 확인할 때 볼 수 있게 만들어보자!
 ㄴ 리드미 작성
 ㄴ 선택 구현 - 일단 위에 내용들 먼저!
 */

/*
 오늘 코드로 무엇을 바꿀 것인가?
 1. Fully implment programmatic code
 2. draw UI similiar to my previous design
 */
 

class ViewController: UIViewController {

//MARK: - Outlet 및 전역 변수 정리
    
    /// 코드로 구성한 테이블 뷰와 버튼들을 어떻게 하면 쉽게 구성할 수 있을까?
    /// Or, 어떻게 하면 생성 단계를 쉽게 할 수 있을까 -
    let todoTableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
        tableView.register(TodoViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .red
        return tableView
    }()
    
    let checkFinishedButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        bt.titleLabel?.text = ""
        bt.setTitle("완료한 일 확인하기", for: .normal)
        bt.backgroundColor = .blue
        bt.setTitleColor(.black, for: .normal)
        bt.layer.cornerRadius = 15
        bt.layer.borderWidth = 1
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(checkFinishedTapped), for: .touchUpInside)
        return bt
    }()
        
    let addTodoButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        bt.titleLabel?.text = ""
        bt.setTitle("할일 추가하기", for: .normal)
        bt.backgroundColor = .yellow
        bt.setTitleColor(.white, for: .normal)
        bt.layer.cornerRadius = 15
        bt.layer.borderWidth = 1
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(addTodoTapped), for: .touchUpInside)
        return bt
    }()
    
    /// 코드 정리하기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        view.addSubview(todoTableView)
        
        /// 이 친구를 어디로 어떻게 배치를 해야할까?
        let stack = UIStackView(arrangedSubviews: [checkFinishedButton, addTodoButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        todoTableView.frame = view.bounds
        
        // Userdefault 데이터 호출
        /// Userdefault를 대체하는 데이터 베이스를 활용해보기 or 후발대 강의처럼 클로저를 활용해보는 것으로
        TodoManager.shared.loadTodos()
        print(TodoManager.list)
    }
    
//MARK: - UIComponent 구성 메서드
    
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
                let newTodo = Todo(id: (TodoManager.list.last?.id ?? -1) + 1, title: title, isCompleted: false, timeStamp: .now)
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
    
    //MARK: - Todo에 반응하는 버튼 조절 메서드 -> 결국 적용 실패!
    
//    fileprivate func updateButton() {
//        let numberOfTodos = min(TodoManager.list.count, 10)
//        let ratio = CGFloat(numberOfTodos) / 10.0
//
//        let newButtonWidth = ratio * checkFinished.frame.size.width
//        let newButton2Width = (1.0 - ratio) * addTodoButton.frame.size.width
//
//        buttonAWidth = newButtonWidth
//        buttonBWidth = newButton2Width
//
//        UIView.animate(withDuration: 0.3) {
//            self.addTodoButton.frame.size.width = self.buttonAWidth
//            self.checkFinished.frame.size.width = self.buttonBWidth
//        }
//    }
    
    //MARK: - IBAction
    
    @objc func checkFinishedTapped(_ sender: UIButton) {
        animateButton(sender)
        let destination = FinishedController()
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true)
    }
    
    
    @objc func addTodoTapped(_ sender: UIButton) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "이름이 변경되는가요? \(section)"
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] action, view, complete in
            guard let self = self else { return }
            
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
                TodoManager.list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            complete(true)
            TodoManager.storeCompleted(todo: todo)
        }
        let actions = UISwipeActionsConfiguration(actions: [complete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}


// MARK: - Findings
/*
 // 새로 생성을 한다고...? 이게 맞을까?
//        for viewController in navigationController?.viewControllers ?? [] {
//            if viewController is FinishedController {
//                navigationController?.popToViewController(viewController, animated: true)
//            }
//        }
 */
