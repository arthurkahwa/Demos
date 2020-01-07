//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 1/7/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class DetailViewControllerTests: XCTestCase {

    var controller: DetaiViewController!
    
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM/dd/yyyy"
      return dateFormatter
    }()
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "DetaiViewController") as? DetaiViewController
        
        controller.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_ControllerHasTitleLabel() {
        
        let titleLabelIsSubView = controller.titleLabel?.isDescendant(of: controller.view) ?? false
        
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_ControllerHasDateLabel() {
        
        let dateLabelIsSubView = controller.dateLabel?.isDescendant(of: controller.view) ?? false
        
        XCTAssertTrue(dateLabelIsSubView)
    }
    
    func test_ControllerHasLocationLabel() {
        
        let locationLabelIsSubView = controller.locationLabel?.isDescendant(of: controller.view) ?? false
        
        XCTAssertTrue(locationLabelIsSubView)
    }
    
    func test_ControllerHasDescriptionLabel() {
        
        let descriptionLabelIsSubView = controller.descriptionLabel?.isDescendant(of: controller.view) ?? false
        
        XCTAssertTrue(descriptionLabelIsSubView)
    }
    
    func test_ControllerHasMapView() {
        
        let mapViewIsSubView = controller.mapView?.isDescendant(of: controller.view) ?? false
        
        XCTAssertTrue(mapViewIsSubView)
    }
    
    func test_SettingItemInfo_SetsTextToLabels() {
        let coordinates = CLLocationCoordinate2DMake(51.3, 7.23)
        
        let location = Location(name: "Foo", coordinate: coordinates)
        let item = ToDoItem(title: "Bar",
                            itemDescription: "Boo",
                            timeStamp: 1456150025,
                            location: location)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        controller.itemInfo = (itemManager, 0)
        
        controller.beginAppearanceTransition(true, animated: true)
        controller.endAppearanceTransition()
        XCTAssertEqual(controller.titleLabel.text, "Bar")
        XCTAssertEqual(controller.dateLabel.text, "02/22/2016")
        XCTAssertEqual(controller.locationLabel.text, "Foo")
        XCTAssertEqual(controller.descriptionLabel.text, "Boo")
        XCTAssertEqual(controller.mapView.centerCoordinate.latitude,
                                   coordinates.latitude,
                                   accuracy: 0.001)
        XCTAssertEqual(controller.mapView.centerCoordinate.longitude,
                                   coordinates.longitude,
                                   accuracy: 0.001)
        
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        
        controller.itemInfo = (itemManager, 0)
        controller.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}
