//
//  CartCreateCustomItemVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CartCreateCustomItemVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var quantityField: CustomTextField!
    @IBOutlet weak var itemImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    // denotes whether or not the user set a custom image
    var didSetImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        nameField.delegate = self
        priceField.delegate = self
        quantityField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        priceField.resignFirstResponder()
        quantityField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCartHomeVC" {
            if segue.destination is CartScreenVC {
                let priceEach = Float(priceField.text?.count == 0 ? "0.00" : priceField.text!)!
                let quantity = Int(quantityField.text?.count == 0 ? "1" : quantityField.text!)!
                
                let itemImage = didSetImage ? itemImageView.image : nil
                let cartItem = CartItem(itemName: nameField.text,
                                        itemPrice: priceEach,
                                        itemQuantity: quantity, image: itemImage)
                cartItem.addToUserSubcartInDatabase()
                CartCreateCustomItemVC.saveCustomItemOnFirestore(item: cartItem)
            }
        }
    }
    
    // Present UIImagePickerController when the user presses the add custom item image button.
    @IBAction func addCustomItemImageButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Set item image when user finishes picking an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImageView.image = image
            didSetImage = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToCartHomeVC" {
            // cancel segue if required field "nameField" is empty
            return nameField.text != ""
        }
        return true
    }
    
    static func saveCustomItemOnFirestore(item: CartItem) {
        print("saving custom item on db")
        let itemUID = UUID().uuidString

        let db = Firestore.firestore()
        var data: [String:Any] = ["itemName": item.itemName!,
                                  "itemPrice": item.itemPrice,
                                  "lastUpdated": FieldValue.serverTimestamp(),
                                  "imageURL": "none"]
        
        let itemDoc = db.collection("users").document(Auth.auth().currentUser!.uid).collection("customItems").document(itemUID)
        
        // if img is not nil, upload to cloudstore
        if let img = item.image, let imageData = img.jpegData(compressionQuality: 0.1) {
            print("uploading image")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let storage = Storage.storage()
            let itemImageRef = storage.reference().child("custom_item_images").child(Auth.auth().currentUser!.uid).child("\(itemUID).jpeg")
            
            itemImageRef.putData(imageData, metadata: metaData) { metaData, error in
                guard metaData != nil else {
                    print("cart item image upload error")
                    return
                }
                print("cart item \(item.itemName!) image uploaded to cloudstore")
                // get image url
                itemImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    print("image url:\(downloadURL)")
                    // image url obtained, update cartItem data in firestore
                    data["imageURL"] = downloadURL.absoluteString
                    // set data AFTER image upload has finished
                    itemDoc.setData(data)
                }
            }
        } else {
            // set data with no image url
            itemDoc.setData(data)
        }
    }
}
