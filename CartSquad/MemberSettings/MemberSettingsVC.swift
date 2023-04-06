//
//  MemberSettingsVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/5/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class MemberSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var settingsTable: UITableView!
    let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We only need 3 types of cells
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var result:UITableViewCell!
        switch indexPath.row {
        case 0:
            var cell = settingsTable.dequeueReusableCell(withIdentifier: "privilegesCell", for: indexPath) as? PrivilegeSettingsCell
            break
        case 1:
            var cell = settingsTable.dequeueReusableCell(withIdentifier: "budgetCell", for: indexPath) as? BudgetSettingsCell
            break
        case 2:
            var cell = settingsTable.dequeueReusableCell(withIdentifier: "restrictionsCell", for: indexPath) as? RestrictedItemsSettingsCell
            break
        default:
            // Should not happen
            result = nil
            break
        }
        
        return result
    }
    
    @IBAction func removeCartMember(_ sender: Any) {
        
    }
}
