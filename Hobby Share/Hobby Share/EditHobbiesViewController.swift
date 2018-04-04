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

        // self.view.setNeedsDisplay()

        var cellsToColorRed = [HobbyCollectionViewCell]()

        for case let visibleCell as HobbyCollectionViewCell in availableHobbiesCollectionView.visibleCells {
            visibleCell.backgroundColor = UIColor.darkGray

            for hobby in self.myHobbies! {
                if hobby.hobbyName?.caseInsensitiveCompare(visibleCell.hobbyLabel.text!) == ComparisonResult.orderedSame {
                    cellsToColorRed.append(visibleCell)
                }
            }
        }

        for cellToColorRed in cellsToColorRed {
            cellToColorRed.backgroundColor = UIColor.red
        }
    }

    /*
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HobbyCollectionViewCell
        for hobby in myHobbies! {
            if hobby.hobbyName?.caseInsensitiveCompare(cell.hobbyLabel.text!) == ComparisonResult.orderedSame {
                cell.contentView.backgroundColor = UIColor.red

                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    */

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HobbyCollectionViewCell

        if collectionView == availableHobbiesCollectionView {
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]

            for myHobby in myHobbies! {
                if myHobby.hobbyName?.caseInsensitiveCompare(cell.hobbyLabel.text!) == ComparisonResult.orderedSame {
                    // cell.contentView.backgroundColor = UIColor.red

                    // self.view.reloadInputViews()
                }
            }

            if myHobbies?.contains(where: {$0.hobbyName == hobby.hobbyName}) == false {
                if myHobbies!.count < kMaxHobbyCount {
                    myHobbies! += [hobby]
                    self.saveHobbies()
                }
                else {
                    let alert = UIAlertController(title: kAppTitle, message: "Replace one of the following with \(String(describing: hobby.hobbyName))", preferredStyle: .actionSheet)

                    // let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    for myHobby in myHobbies! {
                        let alertAction = UIAlertAction(title: myHobby.hobbyName, style: .destructive, handler: {(action) in
                            if action.title?.caseInsensitiveCompare(myHobby.hobbyName!) == ComparisonResult.orderedSame {
                                let i = self.myHobbies?.index(of: myHobby)
                                self.myHobbies?.remove(at: i!)
                                self.saveHobbies()

                                self.myHobbies?.append(hobby)
                                self.saveHobbies()
                            }
                        })
                        alert.addAction(alertAction)
                    }

                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                    })

                    //alert.addAction(okayAction)
                    alert.addAction(cancelAction)

                    self.present(alert, animated: true)
                }
            }
            else {
                print("Hobby " + hobby.hobbyName! + " is already in the list")
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

        // self.view.reloadInputViews()
        // availableHobbiesCollectionView.setNeedsLayout()
        // self.myHobbiesCollectionView.setNeedsDisplay()

        /*
        for hobby in self.myHobbies! {
            if hobby.hobbyName?.caseInsensitiveCompare(cell.hobbyLabel.text!) == ComparisonResult.orderedSame {
                cell.contentView.backgroundColor = UIColor.red
            }
            else {
                cell.contentView.backgroundColor = UIColor.darkGray
            }
        }
        */
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
