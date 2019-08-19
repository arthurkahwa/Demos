//
//  TeamDetailViewController.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/18/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {

    var team: Team!
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var countryOfOrigin: UILabel!
    @IBOutlet weak var driver1: UILabel!
    @IBOutlet weak var driver2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = team.name
        
        teamName.text = team.name
        countryOfOrigin.text = team.countryOfOrigin
        driver1.text = team.drivers![0].name
        driver2.text = team.drivers![1].name
        
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
