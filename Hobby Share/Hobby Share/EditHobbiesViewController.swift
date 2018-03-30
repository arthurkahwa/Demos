//
//  EditHobbiesViewController.swift
//  Hobby Share
//
//  Created by Arthur Nsereko Kahwa on 02/10/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class EditHobbiesViewController: HobbyShareViewController {


    @IBOutlet weak var availableHobbiesCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.availableHobbiesCollectionView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Collection View Customization
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let resusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HobbyCategoryHeader", for: indexPath)

        (resusableView as! HobbiesCollectionViewHeader).categoryLabel.text = Array(availableHobbies.keys)[indexPath.section]

        return resusableView
    }

    func saveHobbies() {
        let requestUser = User()
        requestUser.userId = UserDefaults.standard.value(forKey: "CurrentUserId") as? String

        if let myHobbies = self.myHobbies {
            requestUser.hobbies = myHobbies
        }

        HobbyDataProvider().saveHobbies(forUser: requestUser) { (returnedUser) -> () in
            if returnedUser.status.code == 0 {
                self.saveHobbiesToUserDefaults()
                self.myHobbiesCollectionView.reloadData()
            }
            else {
                self.showError(message: returnedUser.status.statusDescription!)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == availableHobbiesCollectionView {
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]

            if myHobbies?.contains(where: {$0.hobbyName == hobby.hobbyName}) == false {
                if myHobbies!.count < kMaxHobbyCount {
                    myHobbies! += [hobby]
                    self.saveHobbies()
                }
                else {
                    let alert = UIAlertController(title: kAppTitle, message: "You may only select up to \(kMaxHobbyCount). Please delete a hobby and try again.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    alert.addAction(okayAction)

                    self.present(alert, animated: true)
                }

            }
        }
        else {
            let alert = UIAlertController(title: kAppTitle, message: "Would you like to delete this Hobby", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) in
                self.myHobbies!.remove(at: indexPath.item)

                self.saveHobbies()
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true)
        }
    }

    // MARK: - Other
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
