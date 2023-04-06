//
//  EditCartSettingsTableViewController.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/30/23.
//

import UIKit
import FirebaseFirestore

class EditCartSettingsTableViewController: UITableViewController, ImagePicker, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageController = UIImagePickerController()
    var cartImage:UIImage? = nil
    let cellIdentifiers:[String] = [
        "CreateCartNameCell",
        "CreateCartImageCell",
        "CreateCartStoreCell",
        "CreateCartDateCell",
        "DeleteCartCell"
    ]
    let rowHeights:[CGFloat] = [
        100,
        160,
        250,
        150,
        150
    ]
    
    var delegate:UIViewController!
    
    var lastDeletedCartId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if cellIdentifiers[row] == "CreateCartImageCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartImageCell
            cell.cartImageView.image = CartScreenVC.currentCart?.image
            
            cell.delegate = self
            return cell
        }
        else if cellIdentifiers[row] == "CreateCartStoreCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartStoreCell

            chosenStore = Store(name: CartScreenVC.currentCart!.store, address: "2025 Guadalupe St STE 01-100, Austin, TX 78705", image: UIImage(named: "targetLogo")!)
            
            cell.disableChangeStore = true

            return cell
        }
        else if cellIdentifiers[row] == "CreateCartNameCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartNameCell
            
            cell.cartNameTF.text = CartScreenVC.currentCart?.name
            
            // Add callback for editing end on cart name cell.
            cell.cartNameTF.addTarget(self, action: #selector(changeCartNameOnFirestore(_:)), for: .editingDidEnd)
            
            return cell
        } else if cellIdentifiers[row] == "CreateCartDateCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartDateCell
            
            cell.dateTF.text = CartScreenVC.currentCart?.date
            cell.timeTF.text = CartScreenVC.currentCart?.time
            
            cell.dateChangeCallback = CartScreenVC.currentCart?.changeCartDateOnFirestore
            cell.timeChangeCallback = CartScreenVC.currentCart?.changeCartTimeOnFirestore
            
            return cell
        } else {
            // Must be DeleteCartCell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath) as! DeleteCartTableViewCell
            
            cell.onDeleteButtonPressed = presentCartDeletionAlert
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        return rowHeights[row]
    }
    
    // Change cart name on firestore
    @objc func changeCartNameOnFirestore(_ textField: UITextField) {
        CartScreenVC.currentCart?.changeCartNameOnFirestore(newName: textField.text!)
    }
    
    
    func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imageController.delegate = self
            imageController.sourceType = .photoLibrary
            imageController.allowsEditing = true
            
            present(imageController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row:1, section:0)) as! CreateCartImageCell
            cell.cartImageView.image = image
            CartScreenVC.currentCart?.changeCartImageOnFirestore(newImage: image)
        }
    }
    
    func changeStore(newStore: Store) {
        chosenStore = newStore
        let cell = self.tableView.cellForRow(at: IndexPath.init(row:2, section:0)) as! CreateCartStoreCell
        cell.storeTable.reloadData()
    }
    
    
    func presentCartDeletionAlert() {
        let deleteAlert = UIAlertController(title: "Delete cart?", message: "This cannot be undone.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.lastDeletedCartId = CartScreenVC.currentCart?.cartID
            CartScreenVC.currentCart?.deleteOnFirestore()
            self.performSegue(withIdentifier: "deletingCartToHomeVC", sender: nil)
        })
        deleteAlert.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deletingCartToHomeVC" {
            if let destination = segue.destination as? MainMenuVC {
                destination.deleteCartWithIdFromCartsList(cartId: lastDeletedCartId!)
            }
        }
    }
}
