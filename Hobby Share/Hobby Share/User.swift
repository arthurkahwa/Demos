//
//  User.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 03/08/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import MapKit

extension Array {
    var allVariablesAreObjects: Bool {
        var retVal = true

        for value in self {
            retVal = value is Hobby
        }

        return retVal
    }

    func toString() -> String {
        var retVal = ""

        if allVariablesAreObjects == false {
            for j in 0...self.count - 1 {
                let value = self[j] as! Hobby

                if j == 0 {
                    retVal +=  value.hobbyName!
                }
                else {
                    retVal += ", " + value.hobbyName!
                }
            }
        }

        return retVal
    }
}

class User: SFLBaseModel, JSONSerializable, MKAnnotation {
    var userId: String?
    var userName: String?
    var latitude: Double?
    var longitude: Double?
    var hobbies = [Hobby]()
    var searchHobby: Hobby?

    override init() {
        super.init()

        self.delegate = self
    }

    init(userName: String) {
        super.init()
        self.delegate = self
        self.userName = userName
    }

    convenience init(userName: String, hobbies: [Hobby], latitude: Double, longitude: Double) {
        self.init(userName: userName)

        self.hobbies = hobbies
        self.latitude = latitude
        self.longitude = longitude
    }

    override func getJSONDictionary() -> NSDictionary {
        let dict = super.getJSONDictionary()
        var jsonSafeHobbiesArray = [String]()

        if self.userId != nil {
            dict.setValue(self.userId, forKey: "UserId")
        }

        if self.userName != nil {
            dict.setValue(self.userName, forKey: "Username")
        }

        if self.latitude != nil {
            dict.setValue(self.latitude, forKey: "Latitude")
        }

        if self.longitude != nil {
            dict.setValue(self.longitude, forKey: "Longitude")
        }

        for hobby in self.hobbies {
            jsonSafeHobbiesArray.append(hobby.hobbyName!)
        }
        dict.setValue(jsonSafeHobbiesArray, forKey: "Hobbies")

        if self.searchHobby != nil {
            dict.setValue(self.searchHobby?.hobbyName, forKey: "HobbySearch")
        }

        print(String(describing: dict))
        return dict
    }

    override func readFromJSONDictionary(dict: NSDictionary) {
        super.readFromJSONDictionary(dict: dict)

        self.userId = dict["UserId"] as? String
        self.userName = dict["Username"] as? String
        self.latitude = dict["Latitude"] as? Double
        self.longitude = dict["Longitude"] as? Double

        let returnedHobbies = dict["Hobbies"] as? NSArray
        if let hobbies = returnedHobbies {
            self.hobbies = Hobby.deserializeHobbies(hobbies: hobbies)
        }
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        }
    }

    var title: String? {
        get {
            return self.userName
        }
    }

    var subtitle: String? {
        get {
            var hobbiesAsString = ""
            for hobby in hobbies {
                hobbiesAsString += hobby.hobbyName! + " "
            }
            print(self.userName! + " " + hobbiesAsString)

            return hobbiesAsString
        }
    }



}
