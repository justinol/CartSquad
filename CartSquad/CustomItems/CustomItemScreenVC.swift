//
//  CustomItemScreenVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/24/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class CustomItemScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var customItemsTableView: UITableView!
    
    var snapshotListener: ListenerRegistration?
    
    var customItems: [CartItem] = [] {
        didSet {
            print("reloading data for custom item add, count \(customItems.count)")
            customItemsTableView.reloadData()
        }
    }
    // Dict to store mapping of cart item names to their cell row
    var customItemNameToCellRow: [String:Int] = [:]
    
    
    var customItemToEdit: CartItem?
    
    override func viewDidLoad() {
        print("custom items screen loaded")
        super.viewDidLoad()
        
        customItemsTableView.dataSource = self
        customItemsTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customItemsTableView.dequeueReusableCell(withIdentifier: "customItemCellReuse", for: indexPath) as! CustomItemTableViewCell
        
        let customItem = customItems[indexPath.row]
        cell.customItem = customItem
        cell.ownerVC = self
        customItemNameToCellRow[customItem.cartItemUID!] = indexPath.row
        
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
                } else if (diff.type == .modified) {
                    // item updated, update data source and UI locally
                    let cellRow = self.customItemNameToCellRow[customItemUID]!
                    self.customItems[cellRow].itemName = itemName
                    self.customItems[cellRow].itemPrice = itemPrice
                    self.customItems[cellRow].imageURL = itemImageURL
                    let cell = self.customItemsTableView.cellForRow(at: IndexPath(row: cellRow, section: 0)) as! CustomItemTableViewCell
                    cell.customItem?.populateCustomItemTableViewCellInfo(cell: cell)
                } else if (diff.type == .removed) {
                    // item removed, update data source and UI locally
                    let cellRow = self.customItemNameToCellRow[itemName]!
                    self.customItems.remove(at: cellRow)
                    self.customItemNameToCellRow[itemName] = nil
                    self.customItemsTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCustomItemEditScreen", let destination = segue.destination as?
            CartCreateCustomItemVC {
            destination.fromCustomItemCreate = false
            destination.fromCustomItemEdit = true
            destination.nameInput = customItemToEdit?.itemName
            destination.priceInput = customItemToEdit?.getPriceString()
            destination.imageInput = customItemToEdit?.image
            destination.customItemToEdit = customItemToEdit
        }
        if segue.identifier == "toCustomItemCreationScreen", let destination = segue.destination as?
            CartCreateCustomItemVC {
            destination.fromCustomItemEdit = false
            destination.fromCustomItemCreate = true
        }
        
    }
    
    func performSegueToCustomItemEditScreen(customItemToEdit: CartItem) {
        self.customItemToEdit = customItemToEdit
       performSegue(withIdentifier: "toCustomItemEditScreen", sender: nil)
    }
    
    @IBAction func unwindToCustomItemHome(segue: UIStoryboardSegue) {
 
    }
    
    @IBAction func newCustomItemButtonPressed(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customItems = []
        customItemNameToCellRow = [:]
        listenForCustomItemChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
    }
    
    deinit {
        // Stop listening for snapshots when this object is deallocated.
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
    }
}
