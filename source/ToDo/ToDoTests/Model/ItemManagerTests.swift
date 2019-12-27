//
//  ItemManagerTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 12/26/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {

    var itemManager: ItemManager!
    
    override func setUp() {
        super.setUp()
        
        itemManager = ItemManager()
    }

    override func tearDown() {
        itemManager = nil
        
        super.tearDown()
    }
    
    func test_toDoCount_Is_Initially_Zero() {
        XCTAssertEqual(itemManager.toDoCount, 0)
    }
    
    func test_doneCount_Is_initially_Zero() {
        XCTAssertEqual(itemManager.doneCount, 0)
    }
    
    func test_AddItem_IncreasesToDoCountToOne() {
        itemManager.add(ToDoItem(title: ""))
        
        XCTAssertEqual(itemManager.toDoCount, 1)
    }
    
    func test_Item_ReturnAddedItem() {
        let item = ToDoItem(title: "Foo")
        
        itemManager.add(item)
        
        let returnedItem = itemManager.item(at: 0)
        XCTAssertEqual(returnedItem.title, item.title)
    }
    
    func test_Check_ItemAt_ChangesCounts() {
        itemManager.add(ToDoItem(title: "Foo"))
        
        itemManager.checkItem(at: 0)
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
    
    func test_ChectItemAt_RemovesItFromToDoItems() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        
        itemManager.add(firstItem)
        itemManager.add(secondItem)
        
        itemManager.checkItem(at: 0)
        
        XCTAssertEqual(itemManager.item(at: 0).title,
                       "Second")
    }
    
    func test_DoneItemAt_ReturnsCheckedItem() {
        let item = ToDoItem(title: "Foo")
        itemManager.add(item)
        
        itemManager.checkItem(at: 0)
        let returnedItem = itemManager.doneItem(at: 0)
        
        XCTAssertEqual(returnedItem.title, item.title)
    }

    func test_RemoveAll_ResultsInCountsBeZero() {
      
        itemManager.add(ToDoItem(title: "Foo"))
        itemManager.add(ToDoItem(title: "Bar"))
        itemManager.checkItem(at: 0)
       
        XCTAssertEqual(itemManager.toDoCount, 1)
        XCTAssertEqual(itemManager.doneCount, 1)
       
        itemManager.removeAll()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 0)
    }
    
    func test_Add_WhenItemIsAlreadyAdded_DoesNotIncreaseCount() {
      
        itemManager.add(ToDoItem(title: "Foo"))
        itemManager.add(ToDoItem(title: "Foo"))
       
        XCTAssertEqual(itemManager.toDoCount, 1)
    }
}
