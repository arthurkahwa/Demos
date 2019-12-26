//
//  LocationTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 12/26/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class LocationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Init_SetsName() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo",
                       "Location name set")
    }
    
    func test_Init_SetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1,
                                                 longitude: 2)
        
        let location = Location(name: "",
                                coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude,
                      coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude,
                       coordinate.longitude)
        
    }
}
