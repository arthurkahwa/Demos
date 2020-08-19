//
//  UnitTests.swift
//  UnitTests
//
//  Created by Arthur Nsereko Kahwa on 8/8/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import HackerRank

class UnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCase0() throws {
        let input = [0,0,1,0,0,1,0]
        let output = jumpingOnClouds(c: input)
        let expected = 4

        XCTAssertEqual(output, 4, "expecting \(expected) but got \(output)")
    }

}
