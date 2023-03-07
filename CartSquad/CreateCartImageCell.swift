//
//  CreateCartImageCell.swift
//  CartSquad
//
//  Created by Justin Lee on 3/6/23.
//

import UIKit

class CreateCartImageCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var cartImageView: UIImageView!
    var delegate:UITableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addImageButtonPressed(_ sender: Any) {
        let otherVC = delegate as! ImagePicker
        otherVC.pickImage()
    }
    
    
}
