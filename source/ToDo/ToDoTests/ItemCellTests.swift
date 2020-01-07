//
//  ItemCellTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 1/5/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}

class ItemCellTests: XCTestCase {

    var tableView: UITableView!
    let dataSource = FakeDataSource()
    var cell: ItemCell!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard
          .instantiateViewController(
            withIdentifier: "ItemListViewController")
          as! ItemListViewController
         
        controller.loadViewIfNeeded()
         
        tableView = controller.tableView
        tableView?.dataSource = dataSource
         
        cell = tableView?.dequeueReusableCell(
          withIdentifier: "ItemCell",
          for: IndexPath(row: 0, section: 0)) as? ItemCell
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK - Tests
    func test_Cell_HasNameLabel() {
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_HasLocationLabel() {
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_HasDateLabel() {
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }

    func test_ConfigCell_SetsTitle() {
        cell.configCell(with: ToDoItem(title: "Foo"))
        
        XCTAssertEqual(cell.titleLabel.text, "Foo")
    }
    
    func test_ConfigCell_SetsDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "06/01/2020")
        let timetamp = date?.timeIntervalSince1970
        
        cell.configCell(with: ToDoItem(title: "Foo",
                                       timeStamp: timetamp))
        
        XCTAssertEqual(cell.dateLabel?.text, "06/01/2020")
    }
    
    func test_Title_WhenItemIsChecked_IsStrukThrough() {
      let location = Location(name: "Bar")
      let item = ToDoItem(title: "Foo",
                          itemDescription: nil,
                          timeStamp: 1456150025,
                          location: location)
       
      cell.configCell(with: item, checked: true)

      let attributedString = NSAttributedString(
        string: "Foo",
        attributes: [NSAttributedString.Key.strikethroughStyle:
            NSUnderlineStyle.single.rawValue])
       
      XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
      XCTAssertNil(cell.locationLabel.text)
      XCTAssertNil(cell.dateLabel.text)
    }
}
