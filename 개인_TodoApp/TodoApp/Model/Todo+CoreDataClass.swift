//
//  Todo+CoreDataClass.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/31.
//
//

import Foundation
import CoreData


public class Todo: NSManagedObject {
    // enum 접근하기
    var category: Categories {
        get {
            return Categories(rawValue: String(self.section!)) ?? .leisure
        }
        set {
            self.section = newValue.rawValue
        }
    }
}
