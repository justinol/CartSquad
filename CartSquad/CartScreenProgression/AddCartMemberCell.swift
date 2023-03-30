//
//  AddCartMemberCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/28/23.
//

import UIKit
import FirebaseFirestore

class AddCartMemberCell: UITableViewCell {

    @IBOutlet weak var userIDField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addCartMemberButtonPressed(_ sender: Any) {
        print("adding cart member \(userIDField.text ?? "noid")")
        if let uid = userIDField.text {
            let db = Firestore.firestore()
            // Get a ref to the user's carts to add them to this cart
            let userCartRef = db.collection("users").document(uid).collection("carts").document((CartScreenVC.currentCart?.cartID)!)
            userCartRef.setData([:])
            
            // Get a ref to the cart's users, add the user to the cart
            let cartRef = db.collection("carts").document((CartScreenVC.currentCart?.cartID)!)
            // Union this uid with those already present in the cart
            cartRef.updateData(["memberUIDs": FieldValue.arrayUnion([uid])])
        }
    }
}
