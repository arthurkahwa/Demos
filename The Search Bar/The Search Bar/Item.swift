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
    var category: String?
    var dateCreated: Date



    init(name: String, value: Int, category: String, serial: String) {
        self.name = name
        self.value = value
        self.serial = serial
        self.category = category
        self.dateCreated = Date()

        super.init()
    }

    convenience init (random: Bool = false) {
        if random {
            let path = Bundle.main.path(forResource: "AdjectivesAndNouns", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)

            let adjectives = dictionary!["adjectives"] as! [String]
            var randomIndex = arc4random_uniform(UInt32(adjectives.count))
            let randowmAdjective: String = adjectives[Int(randomIndex)]

            let nouns = dictionary!["nouns"] as! [String]
            randomIndex = arc4random_uniform(UInt32(nouns.count))
            let randomNoun: String = nouns[Int(randomIndex)]

            let randowmName = "\(randowmAdjective) \(randomNoun)"
            let randowmValue: Int = Int(arc4random_uniform(UInt32(5000)))
            let randowmSerial = UUID().uuidString.components(separatedBy: "-").first!

            let categories = ["good", "bad", "ugly"]
            //, "fair", "charming", "soft", "hard", "unlisted"]
            randomIndex = arc4random_uniform(UInt32(categories.count))
            let randomCategory: String = categories[Int(randomIndex)]

            self.init(name: randowmName, value: randowmValue, category: randomCategory, serial: randowmSerial)
        }
        else {
            self.init(name: "", value: 0, category: "", serial: "")
        }
    }
}
