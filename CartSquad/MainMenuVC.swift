//
//  MainMenuVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/6/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CartAdder {
    
    let cartCellId = "cartCellIdentifier"
    
    @IBOutlet weak var cartTable: UITableView!
    var cartList:[Cart]?
    var selectedCart:Cart? = nil
    
    var snapshotListener: ListenerRegistration?
    var idToCartIndex: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTable.delegate = self
        cartTable.dataSource = self
        
        // Adding carts for testing
        cartList = []
        
        listenForDatabaseCartUpdatesForUser()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get empty cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCellId, for: indexPath)
        
        // Set the labels and image of our cell based on the cell's cart
        let myCart = cartList?[indexPath.row]
        let title = cell.viewWithTag(1) as? UILabel
        title!.text = myCart?.name
        
        let dueDate = cell.viewWithTag(2) as? UILabel
        dueDate!.text = "Due: \( myCart!.date)"
        
        let image = cell.viewWithTag(3) as? UIImageView
        image?.image = myCart!.image
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedCart = cartList![row]
        self.performSegue(withIdentifier: "ToCartIdentifier", sender: self)
    }
    
    func addCart(newCart: Cart) {
        cartList?.append(newCart)
        cartTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCartSegueIdentifer", let destination = segue.destination as?
            CreateCartTableViewController {
            destination.delegate = self
        }
        if segue.identifier == "ToCartIdentifier", let destination = segue.destination as? CartScreenVC {
            destination.createCustomNavBarView(currCart: selectedCart!)
            destination.listenForCartDatabaseUpdates(cartID: selectedCart!.cartID)
            // pass in function to propogate cart changes to main menu
            destination.onCartChangedUpdateMainMenu = { cart in
                let index = self.idToCartIndex[cart.cartID]!
                self.cartList?[index] = cart
                self.cartTable?.reloadData()
            }
        }
    }
    
    // Begin listening to be updated about carts from firebase.
    func listenForDatabaseCartUpdatesForUser() {
        // Should always be authenticated on this screen.
        if let currUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let uid = currUser.uid
            snapshotListener = db.collection("users").document(uid).collection("carts").addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                // User carts changed.
                snapshot.documentChanges.forEach { diff in
                    let cartId = diff.document.documentID
                    // Get cart from carts/ collection
                    let cartRef = db.collection("carts").document(cartId)
                    if diff.type == .added {
                        cartRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                var cartData = document.data()!
                                cartData["cartId"] = cartId
                                _ = Cart(dbCartData: cartData, onFinishInit: { cart in
                                    self.cartList?.append(cart)
                                    self.idToCartIndex[cartId] = self.cartList!.count - 1
                                    self.cartTable?.reloadData()
                                })
                            }
                        }
                    } else if diff.type == .modified {
                        print("cart modified on database")
                    } else if diff.type == .removed {
                        print("cart removed on database")
                        if let cartIndex = self.idToCartIndex[cartId] {
                            self.cartList?.remove(at: cartIndex)
                            self.cartTable?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        // Remove listener for database updates on deinit.
        if let snapshotListener = snapshotListener {
            print("removing snapshot listener on main menu")
            snapshotListener.remove()
        }
    }
    
    @IBAction func unwindToMainMenuVC(segue: UIStoryboardSegue) {
 
    }
}
