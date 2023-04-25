//
//  CartAddCustomItemsVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class CartAddCustomItemsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var customItemsTableView: UITableView!
    
    var snapshotListener: ListenerRegistration?
    
    var customItems: [CartItem] = [] {
        didSet {
            customItemsTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customItemsTableView.delegate = self
        self.customItemsTableView.dataSource = self
        
        listenForCustomItemChanges()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customItemsTableView.dequeueReusableCell(withIdentifier: "customItemReuse2", for: indexPath) as! CustomItemTableViewCell
        
        let customItem = customItems[indexPath.row]
        cell.customItem = customItem
        cell.onAddItemToCart = displayAlertForSuccessfulItemAdd
        cell.ownerVC = nil
        
        return cell
    }
    
    // Ensure constant cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func listenForCustomItemChanges() {
        let db = Firestore.firestore()
        snapshotListener = db.collection("users").document(Auth.auth().currentUser!.uid).collection("customItems").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let customItemData = diff.document.data()
                let itemName = customItemData["itemName"] as! String
                let itemPrice = customItemData["itemPrice"] as! Float
                let itemImageURL = customItemData["imageURL"] as! String
                let customItemUID = diff.document.documentID
                if (diff.type == .added) {
                    let customItem = CartItem(itemName: itemName, itemPrice: itemPrice, imageURL: itemImageURL, cartItemUID: customItemUID)
                    self.customItems.append(customItem)
                }
            }
        }
    }
    
    func displayAlertForSuccessfulItemAdd() {
        let alert = UIAlertController(title: "Successfully added", message: "Added item to cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
    deinit {
        // Stop listening for snapshots when this object is deallocated.
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
    }
}
