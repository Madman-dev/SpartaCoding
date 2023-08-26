//
//  FinishedController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class FinishedController: UIViewController {

    //MARK: - Outlet 및 전역 변수 정리
//    @IBOutlet weak var completedTableView: UITableView!
    let completedTableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
        tableView.backgroundColor = .black
        tableView.register(FinishedCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let returnButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "arrowshape.backward.fill"), for: .normal)
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        completedTableView.frame = view.bounds
        
        completedTableView.dataSource = self
        completedTableView.delegate = self
        
        view.addSubview(completedTableView)
        view.addSubview(returnButton)
        returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        returnButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        
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
        cell.backgroundColor = .blue
        cell.textLabel?.textColor = .red
        return cell
    }
    
    // 선택한 cell 자동 deselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func returnButtonTapped() {
        self.dismiss(animated: true)
    }
}


//MARK: - Findings
/*
 
 button.titleLabel?.text = "이게 올라간건가" >> setTitle만으로 값이 결정되는게 맞네 -> 예전이랑 달라진 구조?
 button.titleLabel?.textColor = .black

 
 - 값이 들어가는 것까지는 확인했지만 inset group으로 구분을 지을 때 section 별로 어떻게 나뉠 수 있는지를 모른다!
 
*/
