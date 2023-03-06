//
//  CartItem.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/4/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class CartItem: NSObject {
    var itemName: String?
    var itemPrice: Float = 0.00
    @objc dynamic var itemQuantity: Int = 0
    var itemTotalCost: Float?
    var image: UIImage?
    
    init(itemName: String? = nil, itemPrice: Float = 0.00, itemQuantity: Int = 1, image: UIImage? = nil) {
        super.init()
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.itemQuantity = itemQuantity
        itemTotalCost = calculateTotalCost()
        self.image = image
    }
    
    func calculateTotalCost() -> Float {
        return itemPrice * Float(itemQuantity)
    }
    
    func populateCartItemTableViewCellInfo(cell: CartItemTableViewCell) {
        cell.itemNameLabel.text = (itemName ?? "")
        cell.itemQuantityField.text = String(itemQuantity)
        if (itemPrice > 0) {
            cell.itemPriceEachLabel.text = "$\(NSString(format: "%.2f", itemPrice) as String) / each"
            cell.itemTotalCost.text = "$\(NSString(format: "%.2f", calculateTotalCost()) as String)"
        } else {
            cell.itemPriceEachLabel.text = "price unspecified"
        }
    }
    
    // Add/Update this cart item to a user's subcart within in a cart in the FireStore database
    func overwriteInUserSubcartInDatabase() {
        print("overwrote \(itemName!) in db")
        let db = Firestore.firestore()
        let cartId = "cart\(0)"
        let data: [String:Any] = ["itemName": itemName!,
                                  "itemPrice": itemPrice,
                                  "itemQuantity": itemQuantity,
                                  "lastUpdated": FieldValue.serverTimestamp()]
        db.collection("carts").document(cartId).collection("users").document(String(AuthUser.userId)).collection("userCartItems").document(itemName!).setData(data)
    }
    
    // Remove this cart item from a user's subcart within in a cart in the FireStore database
    func removeFromUserSubcartInDatabase() {
        let db = Firestore.firestore()
        let cartId = "cart\(0)"
        db.collection("carts").document(cartId).collection("users").document(String(AuthUser.userId)).collection("userCartItems").document(itemName!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document \(self.itemName!) successfully removed!")
            }
        }
    }
}
