//
//  CartAddCustomItemsVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit

class CartAddCustomItemsVC: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func customNavbar() {
        navbar.barTintColor = UIColor.red
    }
}
