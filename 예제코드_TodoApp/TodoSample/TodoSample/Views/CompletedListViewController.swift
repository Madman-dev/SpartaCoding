//
//  CompletedListViewController.swift
//  TodoSample
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class CompletedListViewController: UIViewController {
    
    @IBOutlet weak var completedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        completedTable.delegate = self
        completedTable.dataSource = self
    }
}

extension CompletedListViewController: UITableViewDelegate {
    
}

extension CompletedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoList.completeList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompletedViewCell
        // 이 친구는 어떤 역할을 하는거지?
        let completeList = TodoList.completeList()
        print(completeList)
        cell.setTodo(TodoList.completeList()[indexPath.row])
        return cell
    }
}
