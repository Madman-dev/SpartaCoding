//
//  TodoViewController.swift
//  TodoSample
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class TodoListViewController: UIViewController {
    
    var todo: Todo?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        print("눌렸습니다")
        let alertController = UIAlertController(title: "할 일 추가",
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "할일 추가하기"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let self else { return }
            if let title = alertController.textFields?.first?.text, !title.isEmpty {
                let newItem = Todo(id: (TodoList.list.last?.id ?? -1) + 1, title: title, isCompleted: false)
                TodoList.list.append(newItem)
                self.tableView.insertRows(at: [IndexPath(row: TodoList.list.count-1, section: 0)], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    //    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView?.reloadData()
//    }
}

extension TodoListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoListTableViewCell
        cell.setTodo(TodoList.list[indexPath.row])
        return cell
    }
}
