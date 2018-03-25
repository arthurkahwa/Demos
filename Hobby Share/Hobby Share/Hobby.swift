//
//  Hobby.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 03/08/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

class Hobby: SFLBaseModel, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hobbyName, forKey: "HobbyName")
    }

    required init?(coder aDecoder: NSCoder) {
        self.hobbyName = aDecoder.decodeObject(forKey: "HobbyName") as? String
    }

    var hobbyName: String?

    init(hobbyName: String) {
        super.init()

        self.hobbyName = hobbyName
    }

    class func deserializeHobbies(hobbies: NSArray) -> Array<Hobby> {
        var returnArray = Array<Hobby>()

        for hobby in hobbies {
            if let hobbyName = hobby as? String {
                returnArray.append(Hobby(hobbyName: hobbyName))
            }
        }

        return returnArray
    }
}
