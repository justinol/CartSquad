//
//  CreateCartStoreCell.swift
//  CartSquad
//
//  Created by Justin Lee on 3/6/23.
//

import UIKit

var chosenStore:Store? = nil

class CreateCartStoreCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var storeTable: UITableView!
    
    let noStoreCellIdentifier = "AddStoreCell"
    let selectedStoreCellIdentifier = "SelectedStoreCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storeTable.delegate = self
        storeTable.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chosenStore == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: noStoreCellIdentifier, for: indexPath as IndexPath)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: selectedStoreCellIdentifier, for: indexPath as IndexPath) as! SelectedStoreCell
        
        let selected = chosenStore!
        cell.storeName.text = selected.storeName
        cell.storeAddress.text = selected.storeAddress
        cell.storeImage.image = selected.storeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
