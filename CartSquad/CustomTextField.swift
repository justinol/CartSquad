//
//  CustomTextField.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setBlackBorder()
    }
    
    func setBlackBorder() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10.0
    }
    
    func setClearBorder() {
        layer.borderWidth = 0.0
    }

}
