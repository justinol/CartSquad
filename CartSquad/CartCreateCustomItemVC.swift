//
//  CartCreateCustomItemVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit
import FirebaseFirestore

class CartCreateCustomItemVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var quantityField: CustomTextField!
    
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
            if let destinationVC = segue.destination as? CartScreenVC {
                let priceEach = Float(priceField.text?.count == 0 ? "0.00" : priceField.text!)!
                let quantity = Int(quantityField.text?.count == 0 ? "1" : quantityField.text!)!
                
                let cartItem = CartItem(itemName: nameField.text,
                                        itemPrice: priceEach,
                                        itemQuantity: quantity)
                destinationVC.addItemToUserSubcart(userId: 0, cartItem: cartItem)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToCartHomeVC" {
            // cancel segue if required field "nameField" is empty
            return nameField.text != ""
        }
        return true
    }
}
