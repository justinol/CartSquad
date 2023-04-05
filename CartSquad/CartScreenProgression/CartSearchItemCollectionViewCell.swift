//
//  CartSearchItemCollectionViewCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/4/23.
//

import UIKit

class CartSearchItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var priceFloat: Float!
    var onAddItemToCart: (()->())!
    
    @IBAction func addItemToCartButtonPressed(_ sender: Any) {
        let cartItem = CartItem(itemName: titleLabel.text!,
                                itemPrice: priceFloat,
                                itemQuantity: 1,
                                image: itemImageView.image)
        cartItem.addToUserSubcartInDatabase()
        onAddItemToCart()
    }
    
}
