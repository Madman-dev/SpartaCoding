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
    var category: Categories {
        get {
            return Categories(rawValue: String(self.section!)) ?? .daily
        }
        set {
            self.section = newValue.rawValue
        }
    }
}
