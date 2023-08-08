//
//  FinishedController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class FinishedController: UIViewController {
    @IBOutlet weak var completedTableView: UITableView!
    var completedDatas: [Todo] = []
    // main에서 지정된 값을 next VC로 전달이 가능하다.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print(completedDatas)
        
        completedTableView.dataSource = self
        completedTableView.delegate = self
    }
}

extension FinishedController: UITableViewDelegate {
    
}

extension FinishedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completedTableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath)
        cell.textLabel?.text = completedDatas[indexPath.row].title
        return cell
    }
}
