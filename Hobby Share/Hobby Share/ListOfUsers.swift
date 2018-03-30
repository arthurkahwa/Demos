//
//  ListOfUsers.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 03/08/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class ListOfUsers: SFLBaseModel, JSONSerializable {
    var users = [User]()

    override init() {
        super.init()
        self.delegate = self
    }

    override func readFromJSONDictionary(dict: NSDictionary) {
        super.readFromJSONDictionary(dict: dict)

        if let returnedUsers = dict["ListOfUsers"] as? NSArray {
            for userDictionary in returnedUsers {
                let user = User()
                user.readFromJSONDictionary(dict: userDictionary as! NSDictionary)

                self.users.append(user)
            }
        }
    }

    override func getJSONDictionary() -> NSDictionary {
        let dict = self.getJSONDictionary()

        return dict
    }

    override func getJSONDictionaryString() -> NSString {
        return super.getJSONDictionaryString()
    }
}
