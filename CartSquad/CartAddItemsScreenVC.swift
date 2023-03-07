//
//  CartAddItemsScreenVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit

class CartAddItemsScreenVC: UIViewController {

    @IBOutlet weak var storeSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeSearchBar()
    }
    
    func customizeSearchBar() {
        storeSearchBar.searchBarStyle = .minimal
    }
}
