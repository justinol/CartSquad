//
//  RestrictedItemsSettingsCell.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/6/23.
//

import UIKit

class RestrictedItemsSettingsCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemsTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemsTable.delegate = self
        itemsTable.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

}
