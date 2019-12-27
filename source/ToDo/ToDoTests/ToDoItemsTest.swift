//
//  ToDoItemsTest.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 12/25/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Init_WhenGivenTitle_SetsTitle() {
        let item = ToDoItem(title: "Foo")
        
        XCTAssertEqual(item.title, "Foo",
                       "Title should be set")
    }
    
    func test_Init_WhenGivenDescription_SetsDescription() {
      let item = ToDoItem(title: "Foo",
                   itemDescription: "Bar")
        XCTAssertEqual(item.itemDescription, "Bar",
                       "ItemDescription is set")
    }
    
    func test_Init_Timestamp() {
        let item = ToDoItem(title: "",
                            timeStamp: 42.0)
        XCTAssertEqual(item.timeStamp, 42.0,
                       "timeStamp is set")
    }
    
    func test_Init_SetsLocation() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "",
                            location: location)
        
        XCTAssertEqual(item.location?.name, location.name,
                       "locatrion name is set")
    }
    
    func test_EqualItems_AreEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Foo")
        
        XCTAssertEqual(first, second)
    }
    
    func test_Items_WithDifferentLocations_AreNotEqual () {
        let first = ToDoItem(title: "",
                             location: Location(name: "Foo"))
        let second = ToDoItem(title: "Bar",
                              location: Location(name: "Bar"))
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenOneLocationIsNil_AreNotEqual() {

          var first = ToDoItem(title: "",
                               location: Location(name: "Foo"))
          var second = ToDoItem(title: "",
                                location: nil)


          XCTAssertNotEqual(first, second)
        
        first = ToDoItem(title: "",
                         location: nil)
        second = ToDoItem(title: "",
                          location: Location(name: "Foo"))

        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTimestampsDiffer_AreNotEqual() {

      let first = ToDoItem(title: "Foo",
                           timeStamp: 1.0)
      let second = ToDoItem(title: "Foo",
                            timeStamp: 0.0)
       

      XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenDescriptionsDiffer_AreNotEqual() {

      let first = ToDoItem(title: "Foo",
                           itemDescription: "Bar")
      let second = ToDoItem(title: "Foo",
                            itemDescription: "Baz")
       

      XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTitlesDiffer_AreNotEqual() {
      let first = ToDoItem(title: "Foo")
      let second = ToDoItem(title: "Bar")
     
      
      XCTAssertNotEqual(first, second)
    }
}

