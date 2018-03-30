//
//  NeighborsViewController.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 02/10/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import MapKit

class NeighborsViewController: HobbyShareViewController,
                               MKMapViewDelegate {

    @IBOutlet weak var myNeighborsMapView: MKMapView!

    var users: [User]?

    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myNeighborsMapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - LocationMaaanager
    func centerMapOnCurrentLocation() {
        guard currentLocation != nil else {
            print("Current location is unavailable")

            return
        }

        myNeighborsMapView.setCenter(currentLocation!.coordinate, animated: true)

        let currentRegion = myNeighborsMapView.regionThatFits(MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude), MKCoordinateSpanMake(0.5, 0.5)))

        myNeighborsMapView.setRegion(currentRegion, animated: true)
    }

    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager.stopUpdatingLocation()
        self.centerMapOnCurrentLocation()
        // locationManager.startUpdatingLocation()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let users = self.users {
            // myNeighborsMapView.removeAnnotation(users as! MKAnnotation)
            for user in users {
                myNeighborsMapView.removeAnnotation(user)
            }
        }

        self.fetchUsersWithHobby(hobby: myHobbies![indexPath.row])

        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! HobbyCollectionViewCell

        cell.backgroundColor = UIColor.red

    }

    func fetchUsersWithHobby(hobby: Hobby) {
        let userId = UserDefaults.standard.value(forKey: "CurrentUserId") as? String
        print(userId!)
        if (userId?.isEmpty)! {
                let alert = UIAlertController(title: kAppTitle, message: "Please login before selecting a hobby", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Dingbats", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okayAction)
                self.present(alert, animated: true)

                return
        }

        let requestUser = User()
        requestUser.userId = UserDefaults.standard.value(forKey: "CurrentUserId") as? String

        requestUser.latitude = currentLocation?.coordinate.latitude
        requestUser.longitude = currentLocation?.coordinate.longitude

        UserDataProvider().fetchUserForHobby(user: requestUser, hobby: hobby) {(returnedListOfUsers) in
            if returnedListOfUsers.status.code == 0 {
                self.users = returnedListOfUsers.users

                if let users = self.users {
                    // self.myNeighborsMapView.removeAnnotation(users as! MKAnnotation)
                    for user in users {
                        self.myNeighborsMapView.removeAnnotation(user)
                    }
                }

                if let users = self.users {
                    for user in users {
                        self.myNeighborsMapView.addAnnotation(user)
                    }
                }

                if self.currentLocation != nil {
                    let me = User(userName: "Me", hobbies: self.myHobbies!, latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!)
                    self.myNeighborsMapView.addAnnotation(me)

                    // var neighborsAndMe = [User]()

                    self.users?.append(me)
                    // neighborsAndMe = self.users!
                    self.myNeighborsMapView.showAnnotations(self.users!, animated: true)
                }
                else {
                    self.myNeighborsMapView.showAnnotations(self.users!, animated: true)
                }
            }
            else {
                self.showError(message: returnedListOfUsers.status.statusDescription!)
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
