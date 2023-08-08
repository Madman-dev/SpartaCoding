//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

//MARK: - 이슈 정리
// 1. 데이터 저장이 안된다.
// 2. 지울 때 효과가 없다.
// 3. 어느 시점에 지워야하는지 모른다.
/// currentTitle을 처리하지 않았다 - nil값, 런타임에 꺼진다. > 해결! UIViewController


class ViewController: UIViewController {
//MARK: - Outlet 및 전역 변수 정리
    @IBOutlet weak var checkFinished: UIButton!
    @IBOutlet weak var addTodo: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    var completedData: [Todo] = []
    
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
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "10개 이상은 무리에요", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    
//    @IBAction func checkFinishedTapped(_ sender: UIButton) {
//        print("완료 페이지를 확인합니다.")
//        //prepare와 performsegue의 차이점 - 이전처럼 이미 segue를 IB상 연결해두어서 두번 이뤄지게 된다. -> pushViewcontroller는 넘기는게 아니라 넘어가는거잖아!
//        //        prepare(for: <#T##UIStoryboardSegue#>, sender: <#T##Any?#>)
//        //        performSegue(withIdentifier: "finished", sender: nil)
//        //        navigationController?.pushViewController(completedTodoTableViewController, animated: true)
//        let completedTodoTableViewController = storyboard?.instantiateViewController(withIdentifier: "FinishTodoViewController") as! FinishedController
//        completedTodoTableViewController.completedDatas = completedData
//    }

    
    @IBAction func addTodoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "오늘의 Todo", message: "무엇을 하고 싶으세요?", preferredStyle: .alert)
        
        if TodoManager.list.count >= 10 {
            displayError(message: "맨 위 목표 먼저 마무리해 주세요!")
            return
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "마음껏 작성하세요!"
        }
        
        // can add data, but not persist
        let saveTodo = UIAlertAction(title: "저장하기", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let newTodo = Todo(id: (TodoManager.list.last?.id ?? -1) + 1, title: title, isCompleted: false)
                TodoManager.list.append(newTodo)
                self.todoTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "뒤로 돌아가기", style: .cancel, handler: nil)
        alert.addAction(saveTodo)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    // 여기에서 오류가 발생하고 있었다?? -> 10개 이상 시 에러 처리 안했다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard TodoManager.list.count <= 10 else { print("10개 이상은 안됩니다!"); return 0 }
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
        TodoManager.shared.saveTodo( TodoManager.list)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] _, _,  complete in
            guard let self = self else {
                complete(false)
                return
            }
            
            let todo = TodoManager.list[indexPath.row]
            var updatedTodo = todo
            
            if !todo.isCompleted {
                updatedTodo.isCompleted = true
            } else {
                updatedTodo.isCompleted = false
            }
            
            TodoManager.list[indexPath.row] = updatedTodo
//            tableView.reloadRows(at: [indexPath], with: .automatic) //-> UI도 함께 업데이트 되면서 발생
            complete(true)
            print("완료했습니다.")
        }
        let actions = UISwipeActionsConfiguration(actions: [complete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}

