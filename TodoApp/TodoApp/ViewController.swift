//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var checkFinished: UIButton!
    @IBOutlet weak var addTodo: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    
    var todoData: [Todo] = [
    Todo(title: "내가 오늘 할 일은", isCompleted: false),
    Todo(title: "밥먹기", isCompleted: false),
    Todo(title: "불금 즐기기", isCompleted: false),
    Todo(title: "밖에 나가서 커피 마시기", isCompleted: false),
    Todo(title: "친구들과 대화하기", isCompleted: false),
    Todo(title: "책 읽기", isCompleted: false),
    Todo(title: "오호", isCompleted: false),
    Todo(title: "이것도?", isCompleted: false),
    Todo(title: "안되나?", isCompleted: true),
    ]
    
    var completedTodo: Set<Int> = []
    
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
}

extension ViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Kepp actual data follow up with what's happening on screen - Needs to be lined up correctly
            todoData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /// [weak self]를 여기에 하는 이유는 뭐지? reference cycle이 여기서 생기나?
        /// 아래 코드 flow를 조금 더 이해해봐야겠다
        let complete = UIContextualAction(style: .normal, title: "완료") { [weak self] action, view, complete in
            
            // weak self이기 때문에 있는지 확인 - optional binding
            guard let self = self else { return }
            
            if let cell = tableView.cellForRow(at: indexPath) {
                // 요 부분 살짝 이해 안됨
                let text = cell.textLabel?.text ?? ""
                let attributedText: NSAttributedString
                
                // 선택한 셀의 텍스트가 NSAtrributedString 타입 + strikethrough가 있다면 그냥 text를 리턴하고
                if let attributedOriginalText = cell.textLabel?.attributedText,
                   let _ =  attributedOriginalText.attribute(.strikethroughStyle, at: 0,effectiveRange: nil) {
                    attributedText = NSAttributedString(string: text)
                // 선택한 셀의 텍스트에 어떤 타입도 적용되지 않았다면, 적용해라
                } else {
                    attributedText = NSAttributedString(string: text,
                                                        attributes: [.strikethroughStyle: NSUnderlineStyle.thick.rawValue])
                }
                cell.textLabel?.attributedText = attributedText
                print("완료했습니다.")
                complete(true)
            }
        }
        
        let actions = UISwipeActionsConfiguration(actions: [complete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 이친구는 삭제라기보다 그저 구현데이터? >> 여기서는 어떻게 구현할 수 있을지 모르겠다
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, complete in
//            print("삭제합니다.")
//        }
//        let actions = UISwipeActionsConfiguration(actions: [delete])
//        actions.performsFirstActionWithFullSwipe = false
//        return actions
//    }
}
