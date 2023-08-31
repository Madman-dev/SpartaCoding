//
//  Todo+CoreDataProperties.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/31.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var section: String?
    @NSManaged public var title: String?

}

extension Todo : Identifiable {

}
