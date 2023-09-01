//
//  FinishedController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class FinishedController: UIViewController {

    //MARK: - Outlet 및 전역 변수 정리
    private lazy var completedTableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .red
        tableView.layer.cornerRadius = 20
        tableView.register(FinishedCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let imageView = {
        let imageView = UIImageView()
        imageView.load(url: URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        view.addSubview(completedTableView)
        completedTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        completedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        completedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        completedTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        completedTableView.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension FinishedController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension FinishedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FinishedCell
        cell.backgroundColor = .orange
        cell.textLabel?.textColor = .red
        return cell
    }
    
    // 선택한 cell 자동 deselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
