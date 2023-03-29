//
//  CartItem.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/4/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CartItem: NSObject {
    var itemName: String?
    var itemPrice: Float = 0.00
    @objc dynamic var itemQuantity: Int = 0
    var itemTotalCost: Float?
    var image: UIImage?
    var imageURL: String?
    
    init(itemName: String?, itemPrice: Float = 0.00, itemQuantity: Int = 1, image: UIImage? = nil, imageURL: String? = nil) {
        super.init()
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.itemQuantity = itemQuantity
        itemTotalCost = calculateTotalCost()
        self.image = image
        self.imageURL = imageURL
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
        
        if let img = image {
            // set UI image
            cell.itemImageView.image = img
        }
        else if let imgURL = imageURL {
            if (imgURL != "none") {
                // get image from image url and set
                let storage = Storage.storage()
                let itemImageURLRef = storage.reference(forURL: imgURL)
                itemImageURLRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if error != nil {
                        // error occured
                    } else {
                        if (cell.cartItem != self) {
                            // guard in case cell != cartItem, can happen due to tableview cell reuse
                            return
                        }
                        self.image = UIImage(data: data!)
                        cell.itemImageView.image = self.image
                    }
                }
            }
        }
    }
    
    // Add this cart item to a user's subcart within in a cart in the FireStore database
    func addToUserSubcartInDatabase() {
        print("overwrote \(itemName!) in db")

        let db = Firestore.firestore()
        var data: [String:Any] = ["itemName": itemName!,
                                  "itemPrice": itemPrice,
                                  "itemQuantity": itemQuantity,
                                  "lastUpdated": FieldValue.serverTimestamp(),
                                  "imageURL": "none"]
        
        let itemDoc = db.collection("carts").document(CartScreenVC.currentCartId).collection("users").document(Auth.auth().currentUser!.uid).collection("userCartItems").document(itemName!)
        
        // if img is not nil, upload to cloudstore
        if let img = image, let imageData = img.jpegData(compressionQuality: 0.9) {
            print("uploading image")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let storage = Storage.storage()
            let itemImageRef = storage.reference().child("cart_item_images").child(Auth.auth().currentUser!.uid).child("\(itemName!).jpeg")
            
            itemImageRef.putData(imageData, metadata: metaData) { metaData, error in
                guard metaData != nil else {
                    print("cart item image upload error")
                    return
                }
                print("cart item \(self.itemName!) image uploaded to cloudstore")
                // get image url
                itemImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    print("image url:\(downloadURL)")
                    // image url obtained, update cartItem data in firestore
                    data["imageURL"] = downloadURL.absoluteString
                    // set data AFTER image upload has finished
                    itemDoc.setData(data)
                }
            }
        } else {
            // set data with no image url
            itemDoc.setData(data)
        }
    }
    
    // Update the quantity field only for this cart item in FireStore database.
    func updateQuantityForCartItemInDatabase()  {
        let db = Firestore.firestore()
        let cartItemRef = db.collection("carts").document(CartScreenVC.currentCartId).collection("users").document(Auth.auth().currentUser!.uid).collection("userCartItems").document(itemName!)
        cartItemRef.updateData(["itemQuantity": itemQuantity]) { err in
            if err != nil {
                print("Error updating cart item quantity")
            }
        }
    }
    
    // Remove this cart item from a user's subcart within in a cart in the FireStore database
    func removeFromUserSubcartInDatabase() {
        let db = Firestore.firestore()
        db.collection("carts").document(CartScreenVC.currentCartId).collection("users").document(Auth.auth().currentUser!.uid).collection("userCartItems").document(itemName!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document \(self.itemName!) successfully removed!")
            }
        }
        
        // remove image from cloud storage
        if image != nil || imageURL != "none" {
            let storage = Storage.storage()
            let itemImageRef = storage.reference().child("cart_item_images").child(Auth.auth().currentUser!.uid).child("\(itemName!).jpeg")
            itemImageRef.delete { error in
                if error != nil {
                    print("error deleting image drom db")
                }
            }
        }
    }
}
