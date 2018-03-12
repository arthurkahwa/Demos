//
//  MainItemsTableViewController.swift
//  The Search Bar
//
//  Created by Arthur Nsereko Kahwa on 02/16/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

// MARK: - Search controller extensions
extension MainItemsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension MainItemsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - The main class
class MainItemsTableViewController: UITableViewController {

    var itemStore: ItemStore!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredItems = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.prompt = "otttrr"

        // Setup the search controller in the navigation bar for iOS 11
        searchController.searchBar.scopeButtonTitles = ["All", "good", "bad", "ugly"]
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsSearchResultsButton = true
        searchController.searchBar.placeholder = "Search items"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchController.searchBar.prompt = "\(filteredItems.count) of \(itemStore.allItems.count)"
            return filteredItems.count
        }
        searchController.searchBar.prompt = "\(itemStore.allItems.count) of \(itemStore.allItems.count)"
        return itemStore.allItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ItemCellTableViewCell

        // Configure the cell...
        let item: Item
        if isFiltering() {
            searchController.searchBar.prompt = "\(filteredItems.count) of \(itemStore.allItems.count)"

            item = filteredItems[indexPath.row]
        }
        else {
            item = itemStore.allItems[indexPath.row]
        }

        cell.nameLabel?.text = item.name
        cell.serialLabel?.text = item.category

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        formatter.currencySymbol = "€"

        let valueString = formatter.string(from: NSNumber(value: item.value))
        cell.priceLabel?.text = valueString
        // cell.dateLabel?.text = String(describing: item.dateCreated)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        switch segue.identifier {
        case "showItemDetail"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let item: Item
                if isFiltering() {
                    searchController.searchBar.prompt = "\(filteredItems.count) of \(itemStore.allItems.count)"

                    item = filteredItems[row]
                }
                else {
                    item = itemStore.allItems[row]
                }
                let destinationViewController = segue.destination as! DetailViewController

                destinationViewController.item = item
            }

        default:
            preconditionFailure("Unexpected segue failure")
        }
    }

    // MARK: - Private instance helpers
    func searchBarIsEmpty() -> Bool {
        // return true if there is not text in the search bar
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = itemStore.allItems.filter({(item: Item) -> Bool in
            let doesCategoryMatch = (scope == "All") || (item.category == scope)

            if searchBarIsEmpty() {
                return doesCategoryMatch
            }
            else {
                searchController.searchBar.prompt = "\(filteredItems.count) of \(itemStore.allItems.count)"
                
                return doesCategoryMatch && item.name.lowercased().contains(searchText.lowercased())
            }

        })

        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0

        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}
