//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit
import CoreData

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
    
    //reference to managed object context!!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todos: [Todo]?
    
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
//        TodoManager.shared.loadTodos()
//        print(TodoManager.list)
        
//        fetchData()
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
        
        alert.addTextField{ (textField) in
            textField.placeholder = "마음껏 작성하세요!"
        }
        
        let saveTodo = UIAlertAction(title: "저장하기", style: .default) { [weak self] action in
            guard let self = self else { return }
           
            // 여기에서 발생하는 에러가 있었다. 데이터에 접근하는 방식이 안전하지 않은 것으로 보여짐
            if let textfields = alert.textFields, let textfield = textfields.first?.text, !textfield.isEmpty {
                let newTodo = Todo(context: self.context)
                newTodo.title = textfield
                newTodo.id = 0
                newTodo.isCompleted = true
                newTodo.section = "leisure"
                newTodo.timeStamp = .now
                
                // 데이터 저장
                do {
                    try self.context.save()
                }
                catch {
                    
                }
                
                // refetching the data
                self.fetchData()
                
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
    
    func fetchData() {
        // fetching data from CoreData to display
        do {
            // TodoManager에 있는 데이터를 가져올 수 있도록 노력해보라!
            // 지금은 core data 속에 있는 값들을 다 가지고 와서 list로 넣도록 구성
            self.todos = try context.fetch(Todo.fetchRequest())
            
            // main에서 호출할 수 있도록 thread를 지정하게 된다.
            DispatchQueue.main.async {
                // UI 역할이기 때문에 main 쓰레드에서 진행하도록 하는 것 -> Main이 아니면 에러가 발생?⭐️
                self.todoTableView.reloadData()
            }
        }
        catch {
            
        }
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    // 카테고리 구분
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.allCases.count
    }
    
    
    // 카태고리별로 더미 데이터 구성 필요 -> 각 section별로 채워질 데이터 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        let todo = self.todos?[indexPath.row]
        cell.textLabel?.text = todo?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.todos?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 카테고리 구분 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // ⭐️reach into the sction of category >> 섹션 타이틀을 새로 생성할 때마다 변경할 수 있나? -> 그러면 메시지 입력란을 카테고리 영역 하나 만들어야겠다!
        // Categories 타입이 정확하게 뭔지 몰랐기에 rawValue를 접근할 수 없었다. String으로 지정하게 되면서 타입을 가질 수 있었던 것!
        return Categories.allCases[section].rawValue
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] action, view, complete in
//            guard let self = self else { return }
//            
//            // Todo에 완료 여부(strikeThrough) 확인 및 처리
//            var todo = self.list?[indexPath.row]
////            todo.isCompleted.toggle()
////            self.list[indexPath.row] = todo
//            
//            if let cell = tableView.cellForRow(at: indexPath) as? TodoViewCell {
//                if todo.isCompleted {
////                    cell.textLabel?.attributedText = todo.title.strikeThrough()
////                    TodoManager.completeTodo(todo: todo, isCompleted: true)
//                } else {
//                    cell.textLabel?.attributedText = nil
//                    cell.textLabel?.text = todo.title
////                    TodoManager.completeTodo(todo: todo, isCompleted: false)
//                }
//            }
//            complete(true)
////            TodoManager.storeCompleted(todo: todo)
//        }
//        let actions = UISwipeActionsConfiguration(actions: [complete])
//        actions.performsFirstActionWithFullSwipe = false
//        return actions
//    }
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
