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
    var time: String
    var memberUIDs: [String]
    var cartID: String
    
    // Init from database update
    init(dbCartData: [String:Any], onFinishInit: @escaping(Cart)->()) {
        name = dbCartData["cartName"] as! String
        store = dbCartData["store"] as! String
        date = dbCartData["date"] as! String
        time = dbCartData["time"] as! String
        memberUIDs = (dbCartData["memberUIDs"] as? [String])!
        cartID = (dbCartData["cartId"] as? String)!
        image = UIImage()
        
        // Get image from firebase storage
        let cartImageURL = dbCartData["imageURL"] as! String
        let storage = Storage.storage()
        let cartImageURLRef = storage.reference(forURL: cartImageURL)
        cartImageURLRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                // error occured
            } else {
                self.image = UIImage(data: data!)!
            }
            onFinishInit(self)
        }
    }
    
    // Create a cart on firestore for the first time to save this cart
    // under this user on firestore.
    static func createOnFirestore(name:String, image:UIImage, store:String, date:String, time: String)  {
        print("creating cart using firebase services")
        // should always be signed in on this screen when this is called
        if let currUser = Auth.auth().currentUser {
            // Get auth user's uid.
            let uid = currUser.uid
            // Get firestore db.
            let db = Firestore.firestore()
            
            var cartData: [String:Any] = ["cartName": name, "ownerUID": uid, "imageURL": "none", "store": store, "date": date, "time": time, "memberUIDs": [uid]]
            
            // Create a unique id for the new cart.
            let cartId = UUID().uuidString
            let cartRef = db.collection("carts").document(cartId)
            
            // Get a ref to the user's carts for the new cart.
            let userCartRef = db.collection("users").document(uid).collection("carts").document(cartId)
            
            if let imageData = image.jpegData(compressionQuality: 0.1) {
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
    
    func changeCartNameOnFirestore(newName: String) {
        let db = Firestore.firestore()
        let cartRef = db.collection("carts").document(cartID)
        cartRef.updateData(["cartName": newName]) { err in
            if err != nil {
                print("Error updating cart name")
            }
        }
    }
    
    func changeCartDateOnFirestore(newString: String) {
        let db = Firestore.firestore()
        let cartRef = db.collection("carts").document(cartID)
        cartRef.updateData(["date": newString]) { err in
            if err != nil {
                print("Error updating cart date")
            }
        }
    }
    
    func changeCartTimeOnFirestore(newString: String) {
        let db = Firestore.firestore()
        let cartRef = db.collection("carts").document(cartID)
        cartRef.updateData(["time": newString]) { err in
            if err != nil {
                print("Error updating cart date")
            }
        }
    }
    
    func changeCartImageOnFirestore(newImage: UIImage) {
        print("updating cart image")
        let db = Firestore.firestore()
        let cartRef = db.collection("carts").document(cartID)
        if let imageData = newImage.jpegData(compressionQuality: 0.1) {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let storage = Storage.storage()
            let itemImageRef = storage.reference().child("cart_images").child(cartID).child("cartImage.jpeg")
            
            itemImageRef.putData(imageData, metadata: metaData) { metaData, error in
                guard metaData != nil else {
                    print("cart image upload error")
                    return
                }
                print("cart \(self.cartID) image uploaded to cloudstore")
                // get image url
                itemImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    print("image url:\(downloadURL)")
                    cartRef.updateData(["imageURL": downloadURL.absoluteString])
                }
            }
        }
    }
    
    func deleteOnFirestore() {
        let db = Firestore.firestore()
        let cartRef = db.collection("carts").document(cartID)
        for uid in memberUIDs {
            let userCartRef = db.collection("users").document(uid).collection("carts").document(cartID)
            userCartRef.delete { err in
                if err != nil {
                    print("Error deleting cart from user carts container")
                }
            }
        }
        cartRef.delete { err in
            if err != nil {
                print("Error deleting cart from carts container")
            }
        }
    }
}
