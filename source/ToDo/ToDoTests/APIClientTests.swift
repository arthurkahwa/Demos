//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 1/15/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
@testable import ToDo

extension APIClientTests {
    
    class MockURLSession {
        
        var url: URL?
        
        func dataTask(
            with url: URL,
            completionHandler: @escaping
            (Data?, URLResponse?, Error?) -> Void)
            -> URLSessionDataTask {
                
                self.url = url
                return URLSession.shared.dataTask(with: url)
        }
    }
}

class APIClientTests: XCTestCase {
    
    var client: APIClient!
    
    override func setUp() {
        client = APIClient()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
}
