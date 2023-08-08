//
//  CodedWrong.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/08.
//

import Foundation

/// Doesn't act the way I hoped
//    func completeTodos(at indexPath: IndexPath) {
//        todoData[indexPath.row].isCompleted.toggle()
//
//        if todoData[indexPath.row].isCompleted {
//            let completed = todoData.remove(at: indexPath.row)
//            completedData.append(completed)
//        }
//        todoTableView.reloadData()
//    }

/// 이 친구는 데이터를 저장하는 방식이 아닌 바로 넘길 수 있도록 만들어지는 구조
//    func sendToCompleted(completedTodos: [Todo]) {
//        let vc = FinishedController()
//        vc.completion = completedTodos
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
