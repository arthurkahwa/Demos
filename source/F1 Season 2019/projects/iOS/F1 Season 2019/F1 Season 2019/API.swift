//
//  API.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/19/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

struct API {
    private static let baseUrlString = "http://192.168.2.199:3000/f1/"
    
    static func seasonUrl(to path: String, for type: String) -> URL {
        var fullPath: String
        switch (type) {
        case "image":
            fullPath = baseUrlString + "images/" + path
        case "data":
            fullPath = baseUrlString + path
        default:
            fullPath = baseUrlString
        }
        
        return URL(string: fullPath)!
    }
}
