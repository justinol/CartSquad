//
//  InnerCartTableViewCell.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/2/23.
//

import UIKit

// A class that defines a cell for the table cart screen.
// This class defines how to work with a table view within this cell.
class NestedCartTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTable: UITableView!
    @IBOutlet weak var itemsTableHeightConstraint: NSLayoutConstraint!
    let cellHeight = 70.0
    
    var cartItems: [CartItem] = [] {
        didSet {
            itemsTable.reloadData()
            updateItemsTableHeight()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemsTable.dataSource = self
        itemsTable.delegate = self
        updateItemsTableHeight()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CartItemTableViewCell
        cell.cartItem = cartItems[indexPath.row]
        cell.onDelete = {
            self.cartItems.remove(at: indexPath.row)
            self.itemsTable.reloadData()
        }
        return cell
    }
    
    // Ensure constant cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func updateItemsTableHeight() {
        let numberOfRows = CGFloat(cartItems.count)
        let newHeight = cellHeight * numberOfRows
        
        // update the height constraint of the itemsTable
        itemsTableHeightConstraint.constant = newHeight
        
        // notify the table view to update its layout
        itemsTable.setNeedsLayout()
        
        // notify the parent table view to update its layout as well
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }
    
}
