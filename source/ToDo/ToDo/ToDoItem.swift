//
//  ToDoItem.swift
//  ToDo
//
//  Created by Arthur Nsereko Kahwa on 12/25/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.title != rhs.title { return false }
        if lhs.timeStamp != rhs.timeStamp { return false }
        if lhs.itemDescription != rhs.itemDescription { return false }
        if lhs.location != rhs.location { return false }
        
        return true
    }
    
    let title: String
    let itemDescription: String?
    let timeStamp: Double?
    let location: Location?
    
    init(title: String,
         itemDescription: String? = nil,
         timeStamp: Double? = nil,
         location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timeStamp = timeStamp
        self.location = location
    }
}
