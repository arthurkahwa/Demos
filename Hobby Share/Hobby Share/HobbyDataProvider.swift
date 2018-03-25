//
//  HobbyDataProvider.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 03/09/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

class HobbyDataProvider: NSObject {
    func fetchHobbies() -> [String : [Hobby]] {

        return ["Technology" : [Hobby(hobbyName:"Video Games"),
            Hobby(hobbyName:"Computers"),
            Hobby(hobbyName:"IDEs"),
            Hobby(hobbyName:"Smartphones"),
            Hobby(hobbyName:"Programming"),
            Hobby(hobbyName:"Electronics"),
            Hobby(hobbyName:"Gadgets"),
            Hobby(hobbyName:"Product Reviews"),
            Hobby(hobbyName:"Computer Repair"),
            Hobby(hobbyName:"Software"),
            Hobby(hobbyName:"Hardware"),
            Hobby(hobbyName:"Apple"),
            Hobby(hobbyName:"Google"),
            Hobby(hobbyName:"Microsoft")]]
    }

    func saveHobbies(forUser user: User, completion: @escaping (User) -> ()) {
        let requestUrlString = serverPath + endPoint
        let httpMethod = "SAVE_HOBBIES"
        let requestModel = user

        SFLConnection().ajax(url: requestUrlString as NSString, verb: httpMethod as NSString, requestBody: requestModel) { (returnJSONDict) in
            let returnedUser = User()
            returnedUser.readFromJSONDictionary(dict: returnJSONDict)

            completion(returnedUser)
        }
    }
}
