//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Arthur Nsereko Kahwa on 12/27/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class ItemListDataProvider: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}
