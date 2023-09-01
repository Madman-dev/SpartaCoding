//
//  ViewController.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: - Outlet 및 전역 변수 정리
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todos: [Todo]?
    var textFieldBottomConstraint: NSLayoutConstraint?
    var selectedCategory: Categories?
    var todosByCategory: [Categories: [Todo]] = [:]

    let todoTableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
        tableView.register(TodoViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let tapBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 1
        return view
    }()
    
    lazy var checkFinishedButton: UIButton = {
        let bt = UIButton()
        let image = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        bt.setImage(image, for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.backgroundColor = .clear
        bt.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bt.addTarget(self, action: #selector(checkFinishedTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var sendButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.isHidden = !messageTextField.isEditing
        bt.setTitle("전송", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(addTodoTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var messageTextField: UITextField = {
        let tf = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        tf.attributedPlaceholder = NSAttributedString(string: " 투두를 입력하세요", attributes: attributes)
        tf.textColor = .white
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
        tf.autocorrectionType = .no
        tf.heightAnchor.constraint(equalToConstant: 35).isActive = true
        tf.delegate = self
        tf.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return tf
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 120, height: 30)
        return layout
    }()
    
    private lazy var categoryCollection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .systemPink
        view.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        view.register(SectionViewCell.self, forCellWithReuseIdentifier: "SectionViewCell")
        return view
    }()
    
    //MARK: - 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        todoTableView.dataSource = self
        todoTableView.delegate = self

        view.addSubview(todoTableView)
        todoTableView.frame = view.bounds
        
        let stack = UIStackView(arrangedSubviews: [checkFinishedButton, messageTextField])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillProportionally
        
        view.addSubview(tapBarView)
        tapBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tapBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tapBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        tapBarView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: tapBarView.centerXAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        tapBarView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30).isActive = true
        
        tapBarView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: -10).isActive = true
        sendButton.topAnchor.constraint(equalTo: messageTextField.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageTextField.bottomAnchor).isActive = true
        sendButton.isHidden = true
        
        view.addSubview(categoryCollection)
        categoryCollection.bottomAnchor.constraint(equalTo: tapBarView.topAnchor, constant: 0).isActive = true
        categoryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryCollection.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textFieldBottomConstraint = tapBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        textFieldBottomConstraint?.isActive = true

        fetchData()
    }
    
    //MARK: - 키보드 NotificationCenter
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if keyboardWillShow { viewBottomConstraint.constant = -(keyboardHeight) }
        else { viewBottomConstraint.constant = 0 }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    //MARK: - 에러 대처
    private func displayErrors(error: Errors) {
        let alert: UIAlertController
        
        switch error {
        case .blankTextField:
            alert = UIAlertController(title: "내용이 비어있어요!", message: "투두 작성을 잊으신거 아니실까요?", preferredStyle: .alert)
        case .tooMuchTodos:
            alert = UIAlertController(title: "10개 이상은 집중하기 힘들지 않을까요?", message: "맨 위 목표 먼저 마무리해 주세요", preferredStyle: .alert)
        case .noData:
            alert = UIAlertController(title: "데이터가 없음", message: "데이터를 불러올 수 없었어요", preferredStyle: .alert)
        default:
            alert = UIAlertController(title: "알 수 없는 오류", message: "알 수 없는 오류가 발생했어요!", preferredStyle: .alert)
        }
        
        let dismissAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    //MARK: - 메서드
    // CoreData에 있는 값을 호출하는 방법
    func fetchData() {
        do {
            self.todos = try context.fetch(Todo.fetchRequest())
            DispatchQueue.main.async {
                self.todoTableView.reloadData()
            }
        }
        catch {
            print("데이터 부재 발생: \(error.localizedDescription)")
            displayErrors(error: .noData)
        }
    }
    
    private func addTodo() throws {
        guard let text = messageTextField.text, !text.isEmpty else { throw Errors.blankTextField }
        guard todos!.count < 10 else { throw Errors.tooMuchTodos }
        
        let newTodo = Todo(context: self.context)
        newTodo.title = text
        newTodo.id = 0
        newTodo.isCompleted = true
        newTodo.section = "daily"
        
        do {
            try self.context.save()
            self.fetchData()
        } catch {
            if let customError = error as? Errors {
                print("default 에러 발생: \(customError.localizedDescription)")
                displayErrors(error: customError)
            } else {
                print("데이터 부재 발생: \(error.localizedDescription)")
                displayErrors(error: .noData)
            }
        }
    }
    
    //MARK: - Objc 메서드
    @objc func checkFinishedTapped(_ sender: UIButton) {
        sender.animateButton(sender)
        
        if let navigationController = self.navigationController {
            let destination = FinishedController()
            navigationController.pushViewController(destination, animated: true)
        }
    }
    
    @objc func addTodoTapped(_ sender: UIButton) {
        sender.animateButton(sender)
        do {
            try addTodo()
        } catch Errors.blankTextField {
            print("빈 에러 발생")
            displayErrors(error: .blankTextField)
        } catch Errors.tooMuchTodos {
            print("너무 많은 투두.")
            displayErrors(error: .tooMuchTodos)
        } catch {
            print("에러가 발생했습니다. \(error.localizedDescription)")
        }
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == messageTextField {
            sendButton.isHidden = false
            textField.placeholder = nil
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if messageTextField.isEditing {
            updateViewWithKeyboard(notification: notification, viewBottomConstraint: self.textFieldBottomConstraint!, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: self.textFieldBottomConstraint!, keyboardWillShow: false)
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    // 카테고리 구분
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.allCases.count
//        return todosByCategory[selectedCategory!]?.count ?? 0
    }
    
    // 각 section별로 채워질 데이터 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Categories.allCases[section] == selectedCategory {
            return todos?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoViewCell
        let todo = self.todos?[indexPath.row]
        cell.titleLabel.text = todo?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.todos![indexPath.row]
        let alert = UIAlertController(title: "투두 수정", message: "내용 수정", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = todo.title
        
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
        return Categories.allCases[section].rawValue
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제하기") { (action, view, completionHandler) in
            let remove = self.todos?[indexPath.row]
            if let remove = remove {
                self.context.delete(remove)
            }
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
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
        return Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionViewCell", for: indexPath) as! SectionViewCell
        let category = Categories.allCases[indexPath.item]
        cell.titleLabel.text = category.rawValue
        cell.isSelected = (category == selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = Categories.allCases[indexPath.item]
    }
}
