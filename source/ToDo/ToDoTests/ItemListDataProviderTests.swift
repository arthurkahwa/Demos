//
//  ItemListDataProviderTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 12/27/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

extension ItemListDataProviderTests {
    class MockTableView: UITableView {
        var cellWasDeQueued = false
        
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellWasDeQueued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTableView(withdataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self,
                                   forCellReuseIdentifier: "ItemCell")
            
            return mockTableView
        }
    }
    
    class MockItemCell : ItemCell {
        var configCellWasCalled = false
        var cachedItem: ToDoItem?
        
        override func configCell(with item: ToDoItem,
                                 checked: Bool = false) {
            cachedItem = item
        }
    }
}

class ItemListDataProviderTests: XCTestCase {

    var dataProvider: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!
    var mockTableView: MockTableView!
    
    override func setUp() {
        super.setUp()
    
        dataProvider = ItemListDataProvider()
        dataProvider.itemManager = ItemManager()
        
        mockTableView = MockTableView.mockTableView(withdataSource: dataProvider)
        // mockTableView.dataSource = dataProvider
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "ItemListViewController") as? ItemListViewController
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_numberOfTableSections_IsTwo() {
        let numberOfSectionsInTable = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSectionsInTable, 2)
    }
    
    func test_numberOfRowsInSection1_IsToDoCount() {
        dataProvider.itemManager?.add(ToDoItem(title: "Foo"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        dataProvider.itemManager?.add(ToDoItem(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_NumberOfRows_InSection2_IsDoneCount() {
        dataProvider.itemManager?.add(ToDoItem(title: "Foo"))
        dataProvider.itemManager?.add(ToDoItem(title: "Bar"))
        
        dataProvider.itemManager.checkItem(at: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        dataProvider.itemManager?.checkItem(at: 0)
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func test_CellForRowAt_ReturnsItemCell() {
        dataProvider.itemManager?.add(ToDoItem(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0,
                                                      section: 0))
        
        XCTAssertTrue(cell is ItemCell)
    }
    
    func test_CellForRowAt_DequeuesCellFromTableView() {
        let mockTableView = MockTableView()
        mockTableView.dataSource = dataProvider
        mockTableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        dataProvider.itemManager?.add(ToDoItem(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellWasDeQueued)
    }
    
    func test_CEllForRowAt_CallsConfigCell() {
        mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        let item = ToDoItem(title: "Foo")
        dataProvider.itemManager?.add(item)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.cachedItem, item)
    }
    
    func test_CellForRowAt_Sectin2_CallsConfigCellWithDoneItem() {
        dataProvider.itemManager?.add(ToDoItem(title: "Foo"))
        
        let secondItem = ToDoItem(title: "Bar")
        dataProvider.itemManager?.add(secondItem)
        dataProvider.itemManager?.checkItem(at: 1)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.cachedItem, secondItem)
    }
    
    func test_DeleteButton_InSection_1_ShowsTitle() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(deleteButtonTitle, "Done")
    }
    
    func test_DeleteButton_InSection_2_ShowsTitle() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(deleteButtonTitle, "UnDo")
    }
    
    func test_CheckingAnItem_ChecksItInTheItemManager() {
        dataProvider.itemManager.add(ToDoItem(title: "Foo"))
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(dataProvider.itemManager?.toDoCount, 0)
        XCTAssertEqual(dataProvider.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func test_UnCheckingAnItem_UnChecksItInTheItemManager() {
           dataProvider.itemManager.add(ToDoItem(title: "First"))
        dataProvider.itemManager?.checkItem(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
           
        XCTAssertEqual(dataProvider.itemManager?.toDoCount, 1)
        XCTAssertEqual(dataProvider.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
    
}
