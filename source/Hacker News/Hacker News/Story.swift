//
//  Story.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/1/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

struct Story: Codable {

    let id: Int
    let title: String
    let url: String

    static func placeholder() -> Story {
        return Story(id: 0, title: "N/A", url: "")
    }
}
