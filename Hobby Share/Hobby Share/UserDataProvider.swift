//
//  UserDataProvider.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 03/09/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation

class UserDataProvider: NSObject {
    func getAccountForUser(user: User, completion: @escaping (User) -> ()) {
        let requestUrlString = serverPath + endPoint
        let httpMethod = "CREATE_USER"
        let requestModel = user

        SFLConnection().ajax(url: requestUrlString as NSString, verb: httpMethod as NSString, requestBody: requestModel)  {
            (returnedJSONDict) in
            let dict = NSDictionary(dictionary: returnedJSONDict)
            let returnedUser = User()
            returnedUser.readFromJSONDictionary(dict: dict)

            completion(returnedUser)
            }
    }
}
