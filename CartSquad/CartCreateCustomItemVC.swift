//
//  CartCreateCustomItemVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit

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
                let cartItem = CartItem(itemName: nameField.text, itemPrice: Float(priceField.text ?? "0.00")!, itemQuantity: Int(quantityField.text ?? "1")!)
                destinationVC.addItemToUserSubcart(userId: 0, cartItem: cartItem)
            }
        }
    }
}
