//
//  CustomItemTableViewCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/24/23.
//

import UIKit

class CustomItemTableViewCell: UITableViewCell {
    @IBOutlet weak var customItemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var ownerVC: CustomItemScreenVC!
    var onAddItemToCart: (()->())!
    
    var customItem: CartItem? {
        didSet {
            customItem?.populateCustomItemTableViewCellInfo(cell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func addCustomItemToCartButtonPressed(_ sender: Any) {
        print("adding")
    }
    
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        customItem?.addToUserSubcartInDatabase()
        onAddItemToCart()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        ownerVC.performSegueToCustomItemEditScreen(customItemToEdit: customItem!)
    }
}
