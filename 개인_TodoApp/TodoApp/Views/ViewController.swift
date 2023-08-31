//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit
import CoreData

//MARK: - 요청사항 정리
/*
 필수 구현
 ㄴ userdefault로 데이터 유지 - CRUD (지금은 무엇이 가능한가? > 🔥create, 🔥read, update, 🔥delete > 제대로 되는건 create, read인거 같은데?
 ㄴ ⭐️ tableView section/ header / footer로 구분 - 카테고리별로 구분 짓기 >> inset group으로 정리를 하고 cell에서 섹션을 정리할 수 있을까?
 ㄴ 이미지 url을 활용해서 데이터 호출하기 -> 이건 투두의 디테일을 확인할 때 볼 수 있게 만들어보자!
 ㄴ 리드미 작성
 ㄴ 선택 구현 - 일단 위에 내용들 먼저!
 */
/// Userdefault를 대체하는 데이터 베이스를 활용해보기 or 후발대 강의처럼 클로저를 활용해보는 것으로


/*
 오늘 코드로 무엇을 바꿀 것인가?
 1. Fully implment programmatic code
 2. draw UI similiar to my previous design
 */


class ViewController: UIViewController {
    
    //MARK: - Outlet 및 전역 변수 정리
    
    //reference to managed object context!!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todos: [Todo]?
    var textFieldBottomConstraint: NSLayoutConstraint?
    let data: [String] = [
        "Leisure", "Work", "Personal"
    ]

    
    /// 코드로 구성한 테이블 뷰와 버튼들을 어떻게 하면 쉽게 구성할 수 있을까?
    /// Or, 어떻게 하면 생성 단계를 쉽게 할 수 있을까 -
    let todoTableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
        tableView.register(TodoViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let tapBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var checkFinishedButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "house.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        bt.imageView?.contentMode = .scaleToFill
        bt.backgroundColor = .blue
        bt.layer.cornerRadius = 10
        bt.layer.borderWidth = 1
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(checkFinishedTapped), for: .touchUpInside)
        bt.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    lazy var sendButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
//        bt.backgroundColor = .white
        bt.setTitle("전송", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.addTarget(self, action: #selector(addTodoTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "입력하세요"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.red.cgColor
        tf.layer.masksToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 35).isActive = true
        tf.delegate = self
        tf.autocorrectionType = .no
        return tf
    }()
    
    // 이 친구를 생성하는 이유는?
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = CGSize(width: 10, height: 10)
        return layout
    }()
    
    private lazy var categoryCollection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = true
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.contentInset = .zero
        view.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.register(SectionViewCell.self, forCellWithReuseIdentifier: "SectionViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    /// 코드 정리하기
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        todoTableView.dataSource = self
        todoTableView.delegate = self

        view.addSubview(todoTableView)
        todoTableView.frame = view.bounds
        
        view.addSubview(categoryCollection)
        
        /// 이 친구를 어디로 어떻게 배치를 해야할까?
        let stack = UIStackView(arrangedSubviews: [checkFinishedButton, messageTextField])
        
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillProportionally
        
        view.addSubview(categoryCollection)
        view.addSubview(tapBarView)
        view.addSubview(stack)
        view.addSubview(sendButton)
        
        /// 이걸 끄니까 에러가 없어졌다. 왜지??
//        tapBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tapBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tapBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tapBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        tapBarView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: tapBarView.centerXAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        categoryCollection.bottomAnchor.constraint(equalTo: tapBarView.topAnchor, constant: 0).isActive = true
        categoryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryCollection.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textFieldBottomConstraint = tapBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        textFieldBottomConstraint?.isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: -10).isActive = true
        sendButton.topAnchor.constraint(equalTo: messageTextField.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageTextField.bottomAnchor).isActive = true
        
        // 데이터가 저장이 되었다. > 이전에는 왜 오류가 발생했던 거지? (NSArray0 objectAtIndex:]: index 0 beyond bounds for empty NSArray)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.addSubview(categoryCollection)
//    }
    
    //MARK: - UIComponent 구성 메서드
    
    // 버튼 bounceBack 효과
    fileprivate func animateButton(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: { viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1) }
                           , completion: nil)
        }
    }
    
    
    //MARK: - 에러 대처
    private func displayErrors(for errorType: Errors) {
        let alert: UIAlertController
        
        switch errorType {
        case .blankTextField:
            alert = UIAlertController(title: "내용이 비어있어요!",
                                      message: "투두 작성을 잊으신거 아니실까요?",
                                      preferredStyle: .alert)
        case .tooMuchTodos:
            alert = UIAlertController(title: "10개 이상은 집중하기 힘들지 않을까요?",
                                      message: "맨 위 목표 먼저 마무리해 주세요",
                                      preferredStyle: .alert)
        }
        
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    private func addTodo() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        
        let newTodo = Todo(context: self.context)
        newTodo.title = text
        newTodo.id = 0
        newTodo.isCompleted = true
        newTodo.section = "leisure"
        
        do {
            try self.context.save()
            self.fetchData()
        } catch {
            
        }
    }
    
    //MARK: - Todo에 반응하는 버튼 조절 메서드 -> 결국 적용 실패!
    
    //    fileprivate func updateButton() {
    //        let numberOfTodos = min(TodoManager.list.count, 10)
    //        let ratio = CGFloat(numberOfTodos) / 10.0
    //
    //        let newButtonWidth = ratio * checkFinished.frame.size.width
    //        let newButton2Width = (1.0 - ratio) * addTodoButton.frame.size.width
    //
    //        buttonAWidth = newButtonWidth
    //        buttonBWidth = newButton2Width
    //
    //        UIView.animate(withDuration: 0.3) {
    //            self.addTodoButton.frame.size.width = self.buttonAWidth
    //            self.checkFinished.frame.size.width = self.buttonBWidth
    //        }
    //    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if messageTextField.isEditing {
            updateViewWithKeyboard(notification: notification,
                                   viewBottomConstraint: self.textFieldBottomConstraint!,
                                   keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: self.textFieldBottomConstraint!, keyboardWillShow: false)
    }
    
    func updateViewWithKeyboard(notification: NSNotification,
                                viewBottomConstraint: NSLayoutConstraint,
                                keyboardWillShow: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if keyboardWillShow { viewBottomConstraint.constant = -(keyboardHeight) } // + 30
        else { viewBottomConstraint.constant = 0 }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    
    //MARK: - IBAction
    
    @objc func checkFinishedTapped(_ sender: UIButton) {
        animateButton(sender)
        let destination = FinishedController()
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true)
    }
    
    
    @objc func addTodoTapped(_ sender: UIButton) {
//        self.animateButton(sender)
        addTodo()
    }
    
    // CoreData에 있는 값을 호출하는 방법
    func fetchData() {
        // fetching data from CoreData to display
        do {
            
            // TodoManager에 있는 데이터를 가져올 수 있도록 노력해보라!
            // 지금은 core data 속에 있는 값들을 다 가지고 와서 list로 넣도록 구성
            
            // filter를 적용하는 방법
            //            let filteredRequest = Todo.fetchRequest() as NSFetchRequest<Todo>
            //            let filter = NSPredicate(format: "title contains '이렇게'")
            //            filteredRequest.predicate = filter
            // filteredRequest를 했을 때 적용이 되는 이유는 Todo 타입으로 변환이 되어 있기 때문이다.
            self.todos = try context.fetch(Todo.fetchRequest()) //Todo.fetchRequest()
            
            // main에서 호출할 수 있도록 thread를 지정하게 된다.
            DispatchQueue.main.async {
                // UI 역할이기 때문에 main 쓰레드에서 진행하도록 하는 것 -> Main이 아니면 에러가 발생?⭐️
                self.todoTableView.reloadData()
            }
        }
        catch {
            
        }
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    // 카테고리 구분
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.allCases.count
    }
    
    // 카태고리별로 더미 데이터 구성 필요 -> 각 section별로 채워질 데이터 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        let todo = self.todos?[indexPath.row]
        cell.titleLabel.text = todo?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 투두를 지정하고
        let todo = self.todos![indexPath.row]
        // alert 창을 만들어서
        let alert = UIAlertController(title: "투두 수정", message: "내용 수정", preferredStyle: .alert)
        alert.addTextField()
        
        // 해당 alert의 textField에 접근하고
        let textField = alert.textFields![0]
        textField.text = todo.title
        
        // alert에 버튼을 추가
        let saveButton = UIAlertAction(title: "저장", style: .default) { _ in
            let textfield = alert.textFields![0]
            todo.title = textfield.text
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchData()
        }
        alert.addAction(saveButton)
        present(alert, animated: true)
    }
    
    // 카테고리 구분 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // ⭐️reach into the sction of category >> 섹션 타이틀을 새로 생성할 때마다 변경할 수 있나? -> 그러면 메시지 입력란을 카테고리 영역 하나 만들어야겠다!
        // Categories 타입이 정확하게 뭔지 몰랐기에 rawValue를 접근할 수 없었다. String으로 지정하게 되면서 타입을 가질 수 있었던 것!
        return Categories.allCases[section].rawValue
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    // 삭제 기능을 구현해두기는 했네... 흠...
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제하기") { (action, view, completionHandler) in
            // 내가 지우고 싶은 todo를 지정하고
            let remove = self.todos?[indexPath.row]
            
            // 지정된 todo를 지울 수 있도록 거쳐가야한다.
            if let remove = remove {
                self.context.delete(remove)
            }
            do {
                try self.context.save()
            }
            catch {
                // 에러처리 해보자!
            }
            self.fetchData()
        }
        
        let save = UIContextualAction(style: .normal, title: "저장") { (action, view, completionHandler) in
            let saved = self.todos?[indexPath.row]
            
            if let saved = saved {
                self.context.delete(saved)
            }
            do {
                try self.context.save()
            }
            catch {
                // 에러처리 해보자!
            }
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [delete, save])
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionViewCell", for: indexPath) as! SectionViewCell
//        let data = self.data[indexPath.row]
//        cell.titleLabel.text = data
        cell.backgroundColor = .white
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 80, height: view.frame.height)
    }
}


// MARK: - Findings
/*
 // 새로 생성을 한다고...? 이게 맞을까?
 //        for viewController in navigationController?.viewControllers ?? [] {
 //            if viewController is FinishedController {
 //                navigationController?.popToViewController(viewController, animated: true)
 //            }
 //        }
 */
