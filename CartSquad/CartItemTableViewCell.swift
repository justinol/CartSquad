//
//  CartItemTableViewCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/4/23.
//

import UIKit


// Custom cell for user subcart item's table
class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceEachLabel: UILabel!
    @IBOutlet weak var itemQuantityField: CustomTextField!
    @IBOutlet weak var itemTotalCost: UILabel!
    
    
    var cartItem: CartItem? {
        didSet {
            // Ask cartItem to update this cell's UI.
            cartItem?.populateCartItemTableViewCellInfo(cell: self)
            
            // Add observer to the CartItem's itemQuantity property
            cartItem?.addObserver(self, forKeyPath: "itemQuantity", options: [.old, .new], context: nil)
        }
        willSet {
            // Remove observer to the CartItem's itemQuantity property
            cartItem?.removeObserver(self, forKeyPath: "itemQuantity")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set up the text field's action to call the quantityFieldDidChange method when the text field's value changes
        itemQuantityField.addTarget(self, action: #selector(quantityFieldDidChange(_:)), for: .editingDidEnd)
    }
    
    // Update the cartItem's quantity property with new text field value
    @objc func quantityFieldDidChange(_ textField: UITextField) {
        let newQuantity = Int(textField.text ?? "0") ?? 0
        cartItem?.itemQuantity = newQuantity
        if (newQuantity > 0) {
            // new quantity is > 0, trigger database overwrite for cartItem
            cartItem?.overwriteInUserSubcartInDatabase()
        } else if (newQuantity == 0) {
            // new quantity is 0, trigger database deletion for cartItem
            cartItem?.removeFromUserSubcartInDatabase()
        }
    }
    
    // Observe changes to the CartItem object's itemQuantity property and update UI
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "itemQuantity" {
            cartItem?.populateCartItemTableViewCellInfo(cell: self)
        }
    }
    
    deinit {
        // Remove observer from the CartItem object's itemQuantity property upon cell deallocation
        cartItem?.removeObserver(self, forKeyPath: "itemQuantity")
    }

}
