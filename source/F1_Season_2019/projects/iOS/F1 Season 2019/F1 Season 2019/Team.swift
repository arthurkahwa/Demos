//
//  Team.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/18/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

struct Team: Decodable {
    let id: Int?
    let name: String?
    let countryOfOrigin: String?
    let drivers: [Driver]?
    let logopath: String
    
    var image: Data?
}
