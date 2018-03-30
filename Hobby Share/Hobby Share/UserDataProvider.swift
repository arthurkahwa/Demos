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

    func fetchUserForHobby(user: User, hobby: Hobby, completion: @escaping (ListOfUsers) -> ()) {
        let requestUrlString = serverPath + endPoint
        let httpMethod = "FETCH_USERS_WITH_HOBBY"
        let requestModel = user

        requestModel.searchHobby = hobby

        SFLConnection().ajax(url: requestUrlString as NSString, verb: httpMethod as NSString, requestBody: requestModel) { (returnedJSONDictionary) in
            let dictionary = NSDictionary(dictionary: returnedJSONDictionary)
            let returnedListOfUsers = ListOfUsers()
            returnedListOfUsers.readFromJSONDictionary(dict: dictionary)

            completion(returnedListOfUsers)
        }
    }
}
