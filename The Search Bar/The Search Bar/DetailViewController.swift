//
//  DetailViewController.swift
//  The Search Bar
//
//  Created by Arthur Nsereko Kahwa on 02/17/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serislLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = item.name
        serislLabel.text = item.serial

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        formatter.currencySymbol = "€"

        let valueString = formatter.string(from: NSNumber(value: item.value))
        priceLabel?.text = valueString

        dateLabel.text = String(describing: item.dateCreated)

        categoryLabel.text = item.category
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
