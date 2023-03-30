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
    ]
    let rowHeights:[CGFloat] = [
        100,
        160,
        250,
        150,
    ]
    
    var delegate:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            
            
            chosenStore = nil
            
            return cell
        }
        else if cellIdentifiers[row] == "CreateCartNameCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartNameCell
            
            cell.cartNameTF.text = CartScreenVC.currentCart?.name
            
            // Add callback for editing end on cart name cell.
            cell.cartNameTF.addTarget(self, action: #selector(changeCartNameOnFirestore(_:)), for: .editingDidEnd)
            
            return cell
        } else {
            // Must be CreateCartDateCell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartDateCell
            
            cell.dateTF.text = CartScreenVC.currentCart?.date
            cell.dateChangeCallback = CartScreenVC.currentCart?.changeCartDateOnFirestore
            
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
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        let nameCell = self.tableView.cellForRow(at: IndexPath.init(row:0, section:0)) as! CreateCartNameCell
        let imageCell = self.tableView.cellForRow(at: IndexPath.init(row:1, section:0)) as! CreateCartImageCell
        let selectedStore = chosenStore
        let dateCell = self.tableView.cellForRow(at: IndexPath.init(row:3, section:0)) as! CreateCartDateCell
        
        let nameError = nameCell.cartNameTF.text?.isEmpty
        let imageError = imageCell.cartImageView.image == nil
        let storeError = selectedStore == nil
        let dateError = dateCell.dateTF.text?.isEmpty
        
        if nameError! || imageError || storeError || dateError! {
            let controller = UIAlertController(
                title: "Missing info",
                message: "Please add missing information:",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            
            if nameError! {
                controller.message = "Please add a cart name"
                present(controller, animated: true)
            } else if imageError {
                controller.message = "Please add a cart image"
                present(controller, animated: true)
            } else if storeError {
                controller.message = "Please select a store"
                present(controller, animated: true)
            } else if dateError! {
                controller.message = "Please choose a shop date"
                present(controller, animated: true)
            }
        }
        else {            
//            let otherVC = delegate as! CartAdder
//            otherVC.addCart(newCart: createdCart)
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
}
