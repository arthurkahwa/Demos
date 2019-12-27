//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Arthur Nsereko Kahwa on 12/27/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
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
