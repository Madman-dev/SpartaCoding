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
        tableView.backgroundColor = .white
        tableView.register(FinishedCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    let returnButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setImage(UIImage(named: "arrowshape.backward.fill"), for: .normal)
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let imageView = {
        let imageView = UIImageView()
        // URL로 이미지를 지정
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

        view.addSubview(returnButton)
        returnButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        returnButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
    
    @objc func returnButtonTapped() {
        self.dismiss(animated: true)
    }
}


//MARK: - Findings


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

/*
 
 button.titleLabel?.text = "이게 올라간건가" >> setTitle만으로 값이 결정되는게 맞네 -> 예전이랑 달라진 구조?
 button.titleLabel?.textColor = .black

 
 - 값이 들어가는 것까지는 확인했지만 inset group으로 구분을 지을 때 section 별로 어떻게 나뉠 수 있는지를 모른다!
 
*/
