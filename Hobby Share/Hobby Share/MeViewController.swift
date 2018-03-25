//
//  MeViewController.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 02/10/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import MapKit

class MeViewController: HobbyShareViewController,
                        UITextFieldDelegate
{
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var currentLatitudeLabel: UILabel!
    @IBOutlet weak var currentLongitudeLabel: UILabel!

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if validate() == true {
            submit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Core Location
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)

        currentLatitudeLabel.text = "Latitude: " + String(describing: currentLocation?.coordinate.latitude)
        currentLongitudeLabel.text = "Longitude: " + String(describing: currentLocation?.coordinate.longitude)
    }

    // MARK: - Text Field Delegate
    func validate() -> Bool {
        var valid = false
        if userNameTextField.text != nil && Double((userNameTextField.text?.count)!) > 0 {
            valid = true
        }

        return valid
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validate() == true {
            submit()
        }
        else {
            self.showError(message: "Did you enter a user name?")
        }

        return true
    }

    func submit() {
        userNameTextField.resignFirstResponder()

        let requestUser = User(userName: userNameTextField.text!)
        requestUser.latitude = currentLocation?.coordinate.latitude
        requestUser.longitude = currentLocation?.coordinate.longitude

        UserDataProvider().getAccountForUser(user: requestUser) { (returnedUser) in
            if returnedUser.status.code == 0 {
                self.myHobbies = returnedUser.hobbies

                UserDefaults.standard.set(returnedUser.userId, forKey: "CurrentUserId")
                UserDefaults.standard.synchronize()
            }
            else {
                self.showError(message: returnedUser.status.statusDescription!)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
