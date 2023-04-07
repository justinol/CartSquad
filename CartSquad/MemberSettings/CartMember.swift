//
//  Member.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/6/23.
//

import Foundation
import FirebaseFirestore

class CartMember {
    private let db = Firestore.firestore()
    var userId:String = ""
    var cartId:String = ""
    var userRef:DocumentReference!
    var cartRef:DocumentReference!
    
    init(userId:String, cartId:String) {
        self.userId = userId
        self.cartId = cartId
        userRef = db.collection("users").document(userId)
        cartRef = db.collection("cart").document(cartId)
    }
    
//    func getPrivileges() -> String {
//        cartRef.collection("users").document(userId)getDocument { (cart, error) in
//            if let memberArray = cart.data()?["memberUIDs"] as? [String], memberArray.contains(uid) {
//
//            }
//        }
//
//        return ""
//    }
//
//    func setPrivileges(privilege:String){
//
//    }
//
//    func getBudget() -> String {
//
//    }
//
//    func setBudget(budget:String) {
//
//    }
//
}
