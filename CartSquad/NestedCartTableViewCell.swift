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
    
    var innerData: [String] = [] {
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
        return innerData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = innerData[indexPath.row]
        return cell
    }
    
    private func updateItemsTableHeight() {
        let rowHeight: CGFloat = 44.0 // set the row height of cells
        let numberOfRows = CGFloat(innerData.count)
        let newHeight = rowHeight * numberOfRows
        
        // update the height constraint of the itemsTable
        itemsTableHeightConstraint.constant = newHeight
        
        // notify the table view to update its layout
        itemsTable.setNeedsLayout()
        
        // notify the parent table view to update its layout as well
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }
    
}
