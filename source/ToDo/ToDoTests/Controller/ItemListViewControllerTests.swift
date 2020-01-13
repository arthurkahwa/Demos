//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 12/27/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {

    var testTarget: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyBoard = UIStoryboard(name: "Main",
                                      bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "ItemListViewController")
        
        testTarget = viewController as? ItemListViewController
        testTarget.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_TableView_AfterViewDidLoad_IsNotNil() {
        
        XCTAssertNotNil(testTarget)
    }
    
    func test_LoadingView_SetsTableDataViewSource() {
        
        XCTAssertTrue(testTarget.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDFelegate() {
        XCTAssertTrue(testTarget.tableView.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_DataSourceEqualsDelegate() {
        XCTAssertEqual(testTarget.tableView.dataSource as? ItemListDataProvider,
                       testTarget.tableView.delegate as? ItemListDataProvider)
    }

}
