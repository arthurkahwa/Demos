//
//  Item.swift
//  The Search Bar
//
//  Created by Arthur Nsereko Kahwa on 02/16/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var value: Int
    var serial: String?
    var dateCreated: Date

    init(name: String, value: Int, serial: String) {
        self.name = name
        self.value = value
        self.serial = serial
        self.dateCreated = Date()

        super.init()
    }

    convenience init (random: Bool = false) {
        if random {
            let randowmAdjective: String = ""
            let randomNoun: String = ""
            let randowmName = "\(randowmAdjective) \(randomNoun)"
            let randowmValue: Int = 0
            let randowmSerial = ""

            self.init(name: randowmName, value: randowmValue, serial: randowmSerial)
        }
        else {
            self.init(name: "", value: 0, serial: "")
        }
    }
}
