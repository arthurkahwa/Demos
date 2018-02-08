//
//  DetailViewController.swift
//  Lend-O-Matic
//
//  Created by Arthur Nsereko Kahwa on 12/27/2017.
//  Copyright © 2017 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            TimeFrameDelegate,
                            MLPAutoCompleteTextFieldDelegate,
                            MLPAutoCompleteTextFieldDataSource {

    // @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var loanDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var loanedItemImage: UIImageView!
    @IBOutlet weak var loanerImage: UIImageView!
    @IBOutlet weak var loanerName: MLPAutoCompleteTextField!
    
    var personImageAdded = false
    var itemImageAdded = false
    
    var loanStart:Date?
    var loanEnd:Date?
    
    enum PicturePurpose {
        case item
        case person
    }
    var picturePurposeSelector:PicturePurpose = .item
    
    var managedObjectContext:NSManagedObjectContext!

    func configureView() {
        // Update the user interface for the detail item.
        if let titleTextField = itemTitleTextField {
            if let borrowedItem = detailItem {
                titleTextField.text = borrowedItem.title
                
                if let availableImageData = borrowedItem.image {
                    loanedItemImage.image = UIImage(data: availableImageData)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                
                if let loanStart = borrowedItem.loanDate {
                    loanDateLabel.text = "Loan start: \(dateFormatter.string(from: loanStart))"
                }
                
                if let loanEnd = borrowedItem.returnDate {
                    returnDateLabel.text = "Loan end: \(dateFormatter.string(from: loanEnd))"
                }
                
                if let associatedPerson = borrowedItem.borrowingPerson {
                    loanerName.text = associatedPerson.name
                    if let personImageData = associatedPerson.image {
                        loanerImage.image = UIImage(data: personImageData)
                    }
                }
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loanerName.autoCompleteDelegate = self
        loanerName.autoCompleteDataSource = self
        loanerName.autoCompleteTableAppearsAsKeyboardAccessory = true
        loanerName.autoCompleteTableBorderColor = UIColor.cyan
        
        let itemGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(DetailViewController.addPictureForItem))
        loanedItemImage.addGestureRecognizer(itemGestureRecognizer)
        
        let personGestureRecogniser =
            UITapGestureRecognizer(target: self,
                                   action: #selector(DetailViewController.addPictureForPerson))
        loanerImage.addGestureRecognizer(personGestureRecogniser)
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: BorrowedItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func selectTimeFrame(_ sender: UIButton) {
    }
    
    @IBAction func saveItem(_ sender: Any) {
        if detailItem == nil {
            // Create new item
            let borrowedItem = BorrowedItem(context: managedObjectContext)
            borrowedItem.title = itemTitleTextField.text
            
            if let itemImage = loanedItemImage.image {
                borrowedItem.image = NSData(data: UIImageJPEGRepresentation(itemImage, 0.3)!) as Data
            }
            
            if let loanStart = loanStart {
                borrowedItem.loanDate = loanStart
            }
            
            if let loanEnd = loanEnd {
                borrowedItem.returnDate = loanEnd
            }
            
            let loanerFetchRequest:NSFetchRequest<BorrowingPerson> = BorrowingPerson.fetchRequest()
            if let loanerName = loanerName.text {
                loanerFetchRequest.predicate = NSPredicate(format: "name == %@", loanerName)
            }
            loanerFetchRequest.fetchLimit = 1
            
            let numberOfResults = try! managedObjectContext.count(for: loanerFetchRequest)
            if numberOfResults == 0 {
                let newLoaner = BorrowingPerson(context: managedObjectContext)
                newLoaner.name = loanerName.text
                
                if let personImageToSave = loanerImage.image {
                    newLoaner.image = NSData(data: UIImageJPEGRepresentation(personImageToSave, 0.3)!) as Data
                }
                
                newLoaner.addToBorrowedItem(borrowedItem)
            }
            else {
                var items = [BorrowingPerson]()
                do {
                    try items = managedObjectContext.fetch(loanerFetchRequest)
                }
                catch {
                    print(error.localizedDescription)
                }
                
                if let foundPerson = items.first {
                    foundPerson.addToBorrowedItem(borrowedItem)
                }
            }
        }
        else {
            if let loanStart = loanStart {
                detailItem?.loanDate = loanStart
            }
            
            if let loanEnd = loanEnd {
                detailItem?.returnDate = loanEnd
            }
        }
        
        do {
            try managedObjectContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func addPictureForItem() {
        picturePurposeSelector = .item
        
        addImageWithPurpose()
    }
    
    @objc func addPictureForPerson() {
        picturePurposeSelector = .person
        
        addImageWithPurpose()
    }
    
    func addImageWithPurpose() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        
        imagePickerViewController.sourceType = .photoLibrary
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    // MARK: ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scaledImage = UIImage.scaleImage(image: image, toWidth: 128, andHeight: 128)
            
            if picturePurposeSelector == .item {
                loanedItemImage.image = scaledImage
                itemImageAdded = true
            }
            else {
                loanerImage.image = scaledImage
                personImageAdded = true
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimeFrameViewController" {
            let timeFrameViewController = segue.destination as! TimeframeViewController
            timeFrameViewController.timeFrameDelegate = self
        }
    }
    
    func didSelectDateRange(range: GLCalendarDateRange) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        loanDateLabel.text = "Loan start: \(dateFormatter.string(from: range.beginDate))"
        returnDateLabel.text = "Loan end: \(dateFormatter.string(from: range.endDate))"
        
        loanStart = range.beginDate
        loanEnd = range.endDate
    }
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, possibleCompletionsFor string: String!) -> [Any]! {
        let fetchRequest:NSFetchRequest<BorrowingPerson> = BorrowingPerson.fetchRequest()
        var borrowingPersonArray = [BorrowingPerson]()
        
        do {
            borrowingPersonArray = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
        
        var nameArray = [String]()
        for person in borrowingPersonArray {
            if let name = person.name {
                nameArray.append(name)
            }
        }
        
        return nameArray
    }
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, didSelectAutoComplete selectedString: String!, withAutoComplete selectedObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) {
        
        let predicate = NSPredicate(format: "name == %@", selectedString)
        
        let fetchRequest:NSFetchRequest<BorrowingPerson> = BorrowingPerson.fetchRequest()
        fetchRequest.predicate = predicate
        
        var selectedPerson:BorrowingPerson?
        
        do {
            selectedPerson = try managedObjectContext.fetch(fetchRequest).first
        }
        catch {
            print(error.localizedDescription)
        }
        
        if let imageData = selectedPerson?.image {
            loanerImage.image = UIImage(data: imageData)
        }
    }
}

