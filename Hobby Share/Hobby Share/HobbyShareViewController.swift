//
//  HobbyShareViewController.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 02/10/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import MapKit

class HobbyShareViewController:
    UIViewController,
    CLLocationManagerDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var myHobbiesCollectionView: UICollectionView!

    let availableHobbies: [String: [Hobby]] = HobbyDataProvider().fetchHobbies()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    var myHobies: [Hobby]? {
        didSet {
            self.myHobbiesCollectionView.reloadData()

            self.saveHobbiesToUserDefaulta()
        }
    }

    func saveHobbiesToUserDefaulta() {
        let hobbyData = NSKeyedArchiver.archivedData(withRootObject: myHobies!)

        UserDefaults.standard.set(hobbyData, forKey:"MyHobbies")
        UserDefaults.standard.synchronize()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways
                ||
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Core Location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!

        manager.stopUpdatingLocation()
        // locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error.debugDescription)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UICollectionView Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myHobbiesCollectionView {
            guard myHobies != nil else {
                return 0
            }
            return myHobies!.count
        }
        else {
            let key = Array(availableHobbies.keys)[section]

            return availableHobbies[key]!.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HobbyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCollectionViewCell", for: indexPath) as! HobbyCollectionViewCell

        if collectionView == myHobbiesCollectionView {
            let hobby = myHobies![indexPath.item]
            cell.hobbyLabel.text = hobby.hobbyName
        }
        else {
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]
            cell.hobbyLabel.text = hobby.hobbyName
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == myHobbiesCollectionView {
            return 1
        }
        else {
            return availableHobbies.keys.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var availableWidth: CGFloat!
        let cellHeight: CGFloat = 54

        var numberOfCells: Int!
        var padding: Int!

        if collectionView == myHobbiesCollectionView {
            numberOfCells = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            padding = 10
        }
        else {
            numberOfCells = 2
            padding = 9
        }

        availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells - 1))

        let dynamicCellWidth = availableWidth / CGFloat(numberOfCells)
        let dynamicCellSize = CGSize(width: dynamicCellWidth, height: cellHeight)

        return dynamicCellSize
    }

    // MARK: - Other
    func showError(message: String) {
        let alert = UIAlertController(title: kAppTitle, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }

}
