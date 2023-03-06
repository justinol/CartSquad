//
//  CartOverviewVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/5/23.
//

import UIKit

class CartOverviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let selfCellID = "selfCellIdentifier"
    let otherCellID = "otherCellIdentifier"
    let addMemberCellID = "addCellIdentifier"
    
    let selfSegueID = "selfProfileSegueIdentifier"
    let otherSegueID = "otherProfileSegueIdentifier"
    
    @IBOutlet weak var memberTable: UITableView!
    var membersList:[Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set this class as the logic handler for the table views
        memberTable.delegate = self
        memberTable.dataSource = self
        
        // Adding fake members for testing stuff
        membersList.append(Member(
            name:"Placeholder Johnson",
            username: "@john",
            items:[("Apple", 5), ("Pear", 1)]
        ))
        
        membersList.append(Member(
            name: "Placeholder Martinez",
            username: "@mart",
            items: [("Takis", 1), ("Ratatouille", 3)]
        ))
        
        membersList[0].addedBy = "No one"
        membersList[1].addedBy = membersList[0].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 cell for each member and 1 for adding new members
        return membersList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determine which kind of cell is being displayed based on the row
        var id:String
        if indexPath.row == 0 {
            // First cell in table belongs to user
            id = selfCellID
        } else if indexPath.row < membersList.count {
            // Any other cell belonging to a person
            id = otherCellID
        } else {
            // Last cell. Corresponds to add members cell
            id = addMemberCellID
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        // This will fail for last cell
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = membersList[indexPath.row].name
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MemberSettingsVC, segue.identifier == selfSegueID {
            destination.delegate = self
            destination.member = membersList[0]
        }
    }

}
