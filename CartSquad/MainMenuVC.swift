//
//  MainMenuVC.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/6/23.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cartCellId = "cartCellIdentifier"
    
    @IBOutlet weak var cartTable: UITableView!
    var cartList:[Cart]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTable.delegate = self
        cartTable.dataSource = self
        
        // Adding carts for testing
        cartList = []
        cartList?.append(Cart(
            name: "Pollos Hermanos",
            image: UIImage(named: "Saul") ?? UIImage(),
            store: "Target",
            date: "2023-03-20")
        )
        cartList?.append(Cart(
            name: "Pizza Party",
            image: UIImage(named: "Pizza") ?? UIImage(),
            store: "HEB",
            date: "2023-03-25")
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get empty cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCellId, for: indexPath)
        
        // Set the labels and image of our cell based on the cell's cart
        let myCart = cartList?[indexPath.row]
        let title = cell.viewWithTag(1) as? UILabel
        title!.text = myCart?.name
        
        let dueDate = cell.viewWithTag(2) as? UILabel
        dueDate!.text = "Due: \( myCart!.date)"
        
        let image = cell.viewWithTag(3) as? UIImageView
        image?.image = myCart!.image
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
