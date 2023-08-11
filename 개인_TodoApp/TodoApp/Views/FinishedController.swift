//
//  FinishedController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class FinishedController: UIViewController {

    //MARK: - Outlet 및 전역 변수 정리
    @IBOutlet weak var completedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        completedTableView.backgroundColor = .black
        
        completedTableView.dataSource = self
        completedTableView.delegate = self
        
        TodoManager.shared.loadTodos()
        completedTableView.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension FinishedController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension FinishedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.completedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FinishedCell
        cell.setTodo(TodoManager.completedList[indexPath.row])
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        return cell
    }
    
    // 선택한 cell 자동 deselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
