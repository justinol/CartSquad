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
}
