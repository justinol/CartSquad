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
