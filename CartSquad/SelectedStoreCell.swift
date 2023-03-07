//
//  SelectedStoreCell.swift
//  CartSquad
//
//  Created by Justin Lee on 3/6/23.
//

import UIKit

class SelectedStoreCell: UITableViewCell {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    
    static let identifier = "SelectedStoreCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
