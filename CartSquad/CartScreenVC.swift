//
//  CartScreenVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/2/23.
//

import UIKit

class CartScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cartTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleStackView
        
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Custom Navbar
    lazy var titleStackView: UIStackView = {
        // Create the horizontal stack view
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        view.addSubview(horizontalStackView)
        
        // Create the image view
        let imageView = UIImageView(image: UIImage(named: "NoImageIcon"))
        imageView.contentMode = .scaleAspectFit
        
        // Create the vertical stack view
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // Create the title label
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        
        // Create the subtitle label
        let subtitleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        subtitleLabel.text = "Shopping at Target"
        subtitleLabel.textColor = .white
        
        // Add the subviews to the stack views
        horizontalStackView.addArrangedSubview(imageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        
        return horizontalStackView
    }()
    
//    var cellData: [[String]] = [["item1-1", "item1-2", "item1-3", "item1-4", "item1-5", "item1-6", "item1-7", "item1-8"], ["item2-1", "item2-2"]]
    
    var cellData: [[CartItem]] = [[CartItem(itemName: "chicken", itemPrice: 5.99, itemQuantity: 1)]]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartCell", for: indexPath) as! NestedCartTableViewCell
        
        cell.cartItems = cellData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func unwindToCartHomeVC(segue: UIStoryboardSegue) {
        
    }
}
