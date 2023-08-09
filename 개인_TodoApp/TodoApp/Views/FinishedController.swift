//
//  FinishedController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class FinishedController: UIViewController {
    
    @IBOutlet weak var completedTableView: UITableView!
    // main에서 지정된 값을 next VC로 전달이 가능하다.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        completedTableView.dataSource = self
        completedTableView.delegate = self
        
        TodoManager.shared.loadTodos()
        completedTableView.reloadData()
    }
}

extension FinishedController: UITableViewDelegate {
    
}

extension FinishedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.completedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FinishedCell
        cell.setTodo(TodoManager.completedList[indexPath.row])
        return cell
    }
}

/// TableView를 직접적으로 호출하는 경우는 없네..?
