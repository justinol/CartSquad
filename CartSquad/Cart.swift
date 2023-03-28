//
//  Cart.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/6/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class Cart {
    var name:String
    var image:UIImage
    var store:String
    var date:String
    var memberUIDs: [String]?
    var cartID: String?
    
    init(name:String, image:UIImage, store:String, date:String) {
        self.name = name
        self.image = image
        self.store = store
        self.date = date
    }
    
    // Call when cart is created by a user for the first time to save this cart
    // under this user on firestore.
    func createOnFirestore()  {
        print("creating cart using firebase services")
        // should always be signed in on this screen when this is called
        if let currUser = Auth.auth().currentUser {
            // Get auth user's uid.
            let uid = currUser.uid
            // Get firestore db.
            let db = Firestore.firestore()
            
            var cartData: [String:Any] = ["cartName": name, "ownerUID": uid, "imageURL": "none", "store": store, "date": date, "memberUIDs": [uid]]
            
            // Create a unique id for the new cart.
            let cartId = UUID().uuidString
            let cartRef = db.collection("carts").document(cartId)
            
            // Get a ref to the user's carts for the new cart.
            let userCartRef = db.collection("users").document(uid).collection("carts").document(cartId)
            
            if let imageData = image.jpegData(compressionQuality: 0.9) {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                let storage = Storage.storage()
                let itemImageRef = storage.reference().child("cart_images").child(cartId).child("cartImage.jpeg")
                
                itemImageRef.putData(imageData, metadata: metaData) { metaData, error in
                    guard metaData != nil else {
                        print("cart image upload error")
                        return
                    }
                    print("cart \(cartId) image uploaded to cloudstore")
                    // get image url
                    itemImageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            return
                        }
                        print("image url:\(downloadURL)")
                        // image url obtained, update cartItem data in firestore
                        cartData["imageURL"] = downloadURL.absoluteString
                        // set data AFTER image upload has finished
                        cartRef.setData(cartData)
                        // make user who created the cart a member of the cart
                        userCartRef.setData([:])
                    }
                }
            } else {
                // no cart image, upload data immediately
                cartRef.setData(cartData)
                // make user who created the cart a member of the cart
                userCartRef.setData([:])
            }
        }
    }
}
