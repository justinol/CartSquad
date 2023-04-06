//
//  CreateCartTableViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 3/6/23.
//

import UIKit

class CreateCartTableViewController: UITableViewController, ImagePicker, UINavigationControllerDelegate, UIImagePickerControllerDelegate, StoreChanger {
    
    var imageController = UIImagePickerController()
    var cartImage:UIImage? = nil
    let cellIdentifiers:[String] = [
        "CreateCartNameCell",
        "CreateCartImageCell",
        "CreateCartStoreCell",
        "CreateCartDateCell",
        "CreateCartSaveCell"
    ]
    let rowHeights:[CGFloat] = [
        100,
        160,
        250,
        150,
        100
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
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if cellIdentifiers[row] == "CreateCartImageCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartImageCell
            
            cell.delegate = self
            return cell
        }
        else if cellIdentifiers[row] == "CreateCartStoreCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath) as! CreateCartStoreCell
            
            chosenStore = nil
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[row], for: indexPath as IndexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        return rowHeights[row]
    }
    
    
    func pickImage(){
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
            Cart.createOnFirestore(name: nameCell.cartNameTF.text!, image: imageCell.cartImageView.image!, store: chosenStore!.storeName, date: dateCell.dateTF.text!, time: dateCell.timeTF.text!)
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeStoreSegueIdentifier", let nextVC = segue.destination as? AddStoreViewController {
            nextVC.delegate = self
        }
        
        if segue.identifier == "AddStoreSegueIdentifier", let nextVC = segue.destination as? AddStoreViewController {
            nextVC.delegate = self
        }
    }
    

}
