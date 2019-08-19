//
//  F1Season.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/18/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

struct F1Season: Decodable {
    let info: String?
    let teams: [Team]?
}
