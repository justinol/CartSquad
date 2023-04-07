//
//  FriendTableViewCell.swift
//  CartSquad
//
//  Created by Justin Lee on 4/6/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var uid:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRemoveButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        
        let removed = db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").document(self.uid)
        removed.delete()
        
//        removeButton.isEnabled = false
//        removeButton.setTitle("Removed", for: .normal)
//        removeButton.setTitleColor(UIColor(named: "Gray"), for: .normal)
        
    }
}
