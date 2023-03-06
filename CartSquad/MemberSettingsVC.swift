//
//  MemberSettingsVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/5/23.
//

import UIKit

class MemberSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addedByLabel: UILabel!
    
    let privilegesId = "privilegesCell"
    let budgetId = "budgetCell"
    let restrictionsId = "restrictionsCell"
    
    var delegate:CartOverviewVC?
    var member:Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all the correct labels
        settingsTable.delegate = self
        settingsTable.dataSource = self
        memberNameLabel.text = member.name
        usernameLabel.text = member.username
        addedByLabel.text = "Added to <Cart title> by \(member.addedBy)"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We only have 3 different cells in this table
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell:UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: privilegesId, for: indexPath)
            let button = cell.viewWithTag(1) as! UIButton
            button.titleLabel?.text = member.privileges
            
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: budgetId, for: indexPath)
            let button = cell.viewWithTag(1) as! UIButton
            if member.budget == -1 {
                button.titleLabel?.text = "None set"
            } else {
                button.titleLabel?.text = String(member.budget)
            }
            
        } else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: restrictionsId, for: indexPath)
            // TODO: Manage the restrictions table
        } else {
            print("Something went wrong in managing the member settings tableView")
            cell = UITableViewCell()
        }
        
        return cell
        
    }

}
