//
//  TeamTableViewController.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/18/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

extension TeamTableViewController: UISearchResultsUpdating {
    // MARK - UISearchResultsUpdating delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class TeamTableViewController: UITableViewController {

    var f1Season = F1Season(info: "", teams: [])
    var filteredTeams = [Team]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a F1 team"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        seasonData {
            (season) in
            
            self.f1Season = season
            self.navigationItem.title = season.info
            
            self.tableView.reloadData()
            self.tableView.rowHeight = 60
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredTeams.count
        }
        return self.f1Season.teams!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamInfoTableViewCell

        var team: Team
        if isFiltering() {
            team = filteredTeams[indexPath.row]
        }
        else {
            team = self.f1Season.teams![indexPath.row]
        }
        
        cell.teamLabel.text = team.name
        
        fetchLogo(imageName: team.logopath) {
            (imageData) in
            
            team.image = imageData
            cell.teamLogo.image = UIImage(data: imageData)
            
            self.tableView.reloadData()
        }
        
        /*
        cell.teamLabel.text = self.f1Season.teams![indexPath.row].name
        
        fetchLogo(imageName: self.f1Season.teams![indexPath.row].logopath) {
            (imageData) in
            
            self.f1Season.teams![indexPath.row].image = imageData
            cell.teamLogo.image = UIImage(data: imageData)
            
            self.tableView.reloadData()
            
        }
        */
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier ==  "showTeamDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let team: Team
                if isFiltering() {
                    team = filteredTeams[row]
                }
                else {
                    team = self.f1Season.teams![row]
                }
                let detailViewController = segue.destination as! TeamDetailViewController
                detailViewController.team = team
            }
        }
    }
 
    
    // MARK - Helpers
    
    func seasonData(completionHandler: @escaping (F1Season) -> Void) {
        let task = URLSession.shared.dataTask(with: API.seasonUrl(to: "teams", for: "data")) {(data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let season = try JSONDecoder().decode(F1Season.self, from: data)
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(season)
                })
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    func fetchLogo(imageName: String, completionHandler: @escaping(Data) -> Void) {
        let task = URLSession.shared.dataTask(with: API.seasonUrl(to: imageName, for: "image")) {(data, response, error) in
            
            DispatchQueue.main.async(execute: {() -> Void in
                completionHandler(data!)
            })
        }
        task.resume()
    }
    
    func prepareImageRequest(data: Data?, error: Error?) -> UIImage {
        guard
        let imageData = data,
            let image = UIImage(data: imageData) else {
                return UIImage()
        }
        return image
    }
    
    func searchIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredTeams = (self.f1Season.teams?.filter({(team: Team) -> Bool in
            return (team.name?.lowercased().contains(searchText.lowercased()))!
        }))!
        
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchIsEmpty()
    }
}
