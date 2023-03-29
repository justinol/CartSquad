//
//  InnerCartTableViewCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/2/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

// A class that defines a cell for a user subcart.
class NestedCartTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTable: UITableView!
    @IBOutlet weak var itemsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addItemsButton: UIButton!
    
    var snapshotListener: ListenerRegistration?
    
    var ownerUID: String? {
        didSet {
            addItemsButton.isHidden = (ownerUID != Auth.auth().currentUser?.uid)
        }
    }
    
    let cellHeight = 70.0
    // Closure to update outer table size provided by outer table.
    var updateOuterTableSize: (() -> Void)?
    
    var cartItems: [CartItem] = [] {
        didSet {
            itemsTable.reloadData()
            updateItemsTableHeight()
        }
    }
    
    // Dict to store mapping of cart item names to their cell row
    var cartItemNameToCellRow: [String:Int] = [:]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        usernameLabel.text = ownerUID!
        itemsTable.dataSource = self
        itemsTable.delegate = self
        updateItemsTableHeight()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CartItemTableViewCell
        let cartItem = cartItems[indexPath.row]
        cell.ownerUID = ownerUID
        cell.itemImageView.image = UIImage(named: "NoImageIcon")
        cell.cartItem = cartItem
        cartItemNameToCellRow[cartItem.itemName!] = indexPath.row
        
        return cell
    }
    
    // Ensure constant cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Allow swipe to remove item.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            cartItems[indexPath.row].removeFromUserSubcartInDatabase()
        }
    }
    
    private func updateItemsTableHeight() {
        let numberOfRows = CGFloat(cartItems.count)
        let newHeight = cellHeight * numberOfRows
        
        // update the height constraint of the itemsTable
        itemsTableHeightConstraint.constant = newHeight
        
        // notify the table view to update its layout
        itemsTable.setNeedsLayout()
        
        // update parent table to reflect changes
        updateOuterTableSize?()
    }
    
    
    // listen for subcart changes from the database (new items/item removal)
    func listenForDatabaseUpdates() {
        let db = Firestore.firestore()
        snapshotListener = db.collection("carts").document(CartScreenVC.currentCartId).collection("users").document(ownerUID!).collection("userCartItems").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let cartItemData = diff.document.data()
                let itemName = cartItemData["itemName"] as! String
                let itemPrice = cartItemData["itemPrice"] as! Float
                let itemQuantity = cartItemData["itemQuantity"] as! Int
                let itemImageURL = cartItemData["imageURL"] as! String
                if (diff.type == .added) {
                    print("adding cart item for id: \(self.ownerUID!)")
                    let cartItem = CartItem(itemName: itemName, itemPrice: itemPrice, itemQuantity: itemQuantity, imageURL: itemImageURL)
                    self.cartItems.append(cartItem)
                } else if (diff.type == .modified) {
                    // item updated, update data source and UI locally
                    let cellRow = self.cartItemNameToCellRow[itemName]!
                    self.cartItems[cellRow].itemQuantity = itemQuantity
                    let cell = self.itemsTable.cellForRow(at: IndexPath(row: cellRow, section: 0)) as! CartItemTableViewCell
                    cell.cartItem?.populateCartItemTableViewCellInfo(cell: cell)
                } else if (diff.type == .removed) {
                    // item removed, update data source and UI locally
                    let cellRow = self.cartItemNameToCellRow[itemName]!
                    self.cartItems.remove(at: cellRow)
                    self.cartItemNameToCellRow[itemName] = nil
                    self.itemsTable.reloadData()
                    self.updateItemsTableHeight()
                }
            }
        }
    }
    
    override func prepareForReuse() {
        // Stop listening for snapshots if this cell had a snapshot listener
        // and will be reused.
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
        if (cartItems.count > 0) {
            cartItems = []
        }
        cartItemNameToCellRow = [:]
        ownerUID = nil
    }
    
    deinit {
        // Stop listening for snapshots when this object is deallocated.
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
    }
}
