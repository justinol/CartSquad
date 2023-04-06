//
//  AddFriendsVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/3/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let database = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var friendList:[Friend] = []
    @IBOutlet weak var friendTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self
        friendTable.dataSource = self
        Friend.getFriendsFromDatabase(userID: userID!, onFinish: refreshTable(friend:))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTable.dequeueReusableCell(withIdentifier: "friendCellIdentifier", for: indexPath) as! AddFriendCell
        let row = indexPath.row
        let friend = friendList[row]
        
        cell.name.text = friend.name
        cell.username.text = friend.username
//        cell.profilePhoto.image = getImageFromURL(imageURL: friend.imageURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let friend = friendList[row]
        let cart = CartScreenVC.currentCart?.cartID
        print("Adding friend to cart!")
        addUserToCart(uid: friend.id, cart: cart!)
    }
    
    func addUserToCart(uid:String, cart:String) {
        
        let cartRef = database.collection("carts").document(cart)
        cartRef.getDocument { (cart, error) in
            if let cart = cart, cart.exists {
                if let memberArray = cart.data()?["memberUIDs"] as? [String], memberArray.contains(uid) {
                    // If user is in the car data, then we don't need to add them!
                    // Present alert
                    print("User is already in cart! Trying to call alert")
                    
                    let alertController = UIAlertController(
                        title: "Can't add user to cart",
                        message: "User might already be added",
                        preferredStyle: .alert)
                    
                    let action = UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: {(action) in self.dismiss(animated: true)})
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true)
                    
                } else {
                    // User is not in cart data; Add them!
                    print("User is not in cart. Adding them!")
                    cartRef.updateData(["memberUIDs":FieldValue.arrayUnion([uid])])
                    self.dismiss(animated: true)
                }
            } else {
                print("Cart does not exist")
            }
        }
        
        self.addCartToUser(uid: uid, cart: cart)
    }
    
    // Called within addUserToCart
    func addCartToUser(uid:String, cart:String) {
        let cartsOfUserRef = database.collection("users").document(uid).collection("carts").document(cart)
        cartsOfUserRef.setData([:])
    }
    
    // Used as a closure after friend information was queried and received
    func refreshTable(friend: Friend) {
        self.friendList.append(friend)
        self.friendTable.reloadData()
    }
    
    func getImageFromURL(imageURL:String) -> UIImage {
        var image:UIImage!
        let storage = Storage.storage()
        
        let cartImageURLRef = storage.reference(forURL: imageURL)
        cartImageURLRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                print("Error while downloading image")
            } else {
                image = UIImage(data: data!)!
            }
        }
        
        return image
    }
}
