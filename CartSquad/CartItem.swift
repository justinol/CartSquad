//
//  CartItem.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/4/23.
//

import Foundation
import UIKit

class CartItem: NSObject {
    var itemName: String?
    var itemPrice: Float?
    @objc dynamic var itemQuantity: Int = 0
    var itemTotalCost: Float?
    var image: UIImage?
    
    init(itemName: String? = nil, itemPrice: Float? = nil, itemQuantity: Int = 0, image: UIImage? = nil) {
        super.init()
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.itemQuantity = itemQuantity
        itemTotalCost = calculateTotalCost()
        self.image = image
    }
    
    func calculateTotalCost() -> Float {
        return (itemPrice ?? 0) * Float(itemQuantity)
    }
    
    func populateCartItemTableViewCellInfo(cell: CartItemTableViewCell) {
        cell.itemNameLabel.text = (itemName ?? "")
        cell.itemPriceEachLabel.text = (NSString(format: "%.2f", itemPrice ?? 0.0) as String) + " / each"
        cell.itemQuantityField.text = String(itemQuantity)
        cell.itemTotalCost.text = (NSString(format: "%.2f", calculateTotalCost()) as String)
    }
}
