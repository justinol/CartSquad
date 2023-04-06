//
//  AddFriendCell.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/5/23.
//

import UIKit

class AddFriendCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
