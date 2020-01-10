//
//  InputViewController.swift
//  ToDo
//
//  Created by Arthur Nsereko Kahwa on 1/10/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locsationYextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
    }
    
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM/dd/yyyy"
      return dateFormatter
    }()
    
    @IBAction func save() {
        guard let titleString = titleTextField.text,
          titleString.count > 0 else { return }
        let date: Date?
        if let dateText = self.dateTextField.text,
          dateText.count > 0 {
          date = dateFormatter.date(from: dateText)
        } else {
          date = nil
        }
        let descriptionString = descriptionTextField.text
        if let locationName = locsationYextField.text,
          locationName.count > 0 {
          if let address = addressTextField.text,
            address.count > 0 {
             

            geocoder.geocodeAddressString(address) {
              [unowned self] (placeMarks, error) -> Void in
               

              let placeMark = placeMarks?.first
               

              let item = ToDoItem(
                title: titleString,
                itemDescription: descriptionString,
                timeStamp: date?.timeIntervalSince1970,
                location: Location(
                  name: locationName,
                  coordinate: placeMark?.location?.coordinate))
               

              self.itemManager?.add(item)
            }
          }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
