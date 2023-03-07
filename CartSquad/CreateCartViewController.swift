//
//  CreateCartViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 3/4/23.
//

import Photos
import PhotosUI
import UIKit

var selectedStore:Store? = Store(name: "Target", address: "123 Guadalupe St.", image: UIImage(named: "targetLogo")!)

class CreateCartViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, StoreChanger {

    @IBOutlet weak var cartDateField: UITextField!
    @IBOutlet weak var cartTimeField: UITextField!
    @IBOutlet weak var storeTable: UITableView!
    @IBOutlet weak var cartImageView: UIImageView!
    
    let noStoreCellIdentifier = "AddStoreCell"
    let selectedStoreCellIdentifier = "SelectedStoreCell"
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeTable.delegate = self
        storeTable.dataSource = self
        cartDateField.delegate = self
        cartTimeField.delegate = self
        
        storeTable.isScrollEnabled = false

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChange(datePicker:)), for: UIControl.Event.valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.preferredDatePickerStyle = .wheels
        
        cartDateField.inputView = datePicker
        cartTimeField.inputView = timePicker
        
    }
    
    
    @IBAction func cartImageButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            self.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
                cartImageView.image = image
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedStore == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: noStoreCellIdentifier, for: indexPath as IndexPath)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: selectedStoreCellIdentifier, for: indexPath as IndexPath) as! SelectedStoreCell
        
        let selected = selectedStore!
        cell.storeName.text = selected.storeName
        cell.storeAddress.text = selected.storeAddress
        cell.storeImage.image = selected.storeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func changeStore(newStore: Store) {
        selectedStore = newStore
        storeTable.reloadData()
    }
    
    // MARK: - Date Changer
    
    @objc func dateChange(datePicker: UIDatePicker) {
        cartDateField.text = formatDate(date: datePicker.date)
    }
    
    @objc func timeChange(datePicker: UIDatePicker) {
        cartTimeField.text = formatTime(time: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    func formatTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }

    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeStoreSegueIdentifier", let nextVC = segue.destination as? AddStoreViewController {
            nextVC.delegate = self
        }
        
        if segue.identifier == "AddStoreSegueIdentifier", let nextVC = segue.destination as? AddStoreViewController {
            nextVC.delegate = self
        }
    }
}
