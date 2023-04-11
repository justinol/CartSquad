//
//  UserTableViewCell.swift
//  CartSquad
//
//  Created by Justin Lee on 4/6/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var uid:String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onAddButtonPressed(_ sender: Any) {
//        addButton.isEnabled = false
//        addButton.setTitle("Requested", for: .normal)
//        addButton.setTitleColor(UIColor(named: "Gray"), for: .normal)
        let db = Firestore.firestore()
        let addToMyFriends = db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").document(self.uid!)
        addToMyFriends.setData([:])

        let addToTheirFriends = db.collection("users").document(self.uid!).collection("friends").document(Auth.auth().currentUser!.uid)
        addToTheirFriends.setData([:])
    }
    
}
