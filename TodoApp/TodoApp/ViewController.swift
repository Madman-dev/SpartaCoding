//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var checkFinished: UIButton!
    @IBOutlet weak var addTodo: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    let todoData = [
    Todo(title: "내가 오늘 할 일은"),
    Todo(title: "밥먹기"),
    Todo(title: "불금 즐기기"),
    Todo(title: "밖에 나가서 커피 마시기"),
    Todo(title: "친구들과 대화하기"),
    Todo(title: "책 읽기"),
    Todo(title: "오호"),
    Todo(title: "이것도?"),
    Todo(title: "안되나?"),
//    Todo(title: "안되나?"),
//    Todo(title: "안되나?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // currentTitle을 처리하지 않았다 - nil값, 런타임에 꺼진다. > 해결! UIViewController
        addTodo.setTitle("할일 추가하기", for: .normal)
        checkFinished.setTitle("완료한 일 확인하기", for: .normal)
        
        // 완료 확인 버튼 생성
        checkFinished.backgroundColor = .yellow
        checkFinished.setTitleColor(.black, for: .normal)
        checkFinished.layer.cornerRadius = 15
        checkFinished.layer.borderWidth = 1
        checkFinished.clipsToBounds = true
        
        // 투두 버튼 생성
        addTodo.backgroundColor = .black
        addTodo.setTitleColor(.white, for: .normal)
        addTodo.layer.cornerRadius = 15
        addTodo.layer.borderWidth = 1
        addTodo.clipsToBounds = true
        
        // 테이블뷰가 가지고 있는 권한을 너한테 넘겨준다~
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    @IBAction func checkFinishedTapped(_ sender: UIButton) {
        print("완료 버튼이 눌렸습니다")
    }
    
    @IBAction func addTodoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "오늘의 Todo", message: "무엇을 하고 싶으세요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "뒤돌아가기", style: .cancel, handler: nil))
        
        alert.addTextField{ (textField) in
            textField.placeholder = "마음껏 작성하세요!"
        }
        
        alert.addAction(UIAlertAction(title: "저장하기", style: .default, handler: { action in
            if let title = alert.textFields?.first?.text {
                print("정보 저장 \(title)")
            }
        }))
        
        present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard todoData.count <= 10 else { print("10개 이상은 안됩니다!"); return 10 }
        return todoData.count
    }
    
    // cell을 재사용하는 영역
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todoData[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = todo.title // 이부분은 이해해봐야겠다
        return cell
    }
}

