//
//  CartScreenVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/2/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class CartScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cartTable: UITableView!
    
    var currentCart:Cart?
    static var currentCartId: String!
    
    var snapshotListener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        CartScreenVC.currentCartId = currentCart!.cartID
        navigationItem.titleView = titleStackView
        
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        listenForCartDatabaseUpdates()
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
//        let imageView = UIImageView(image: currentCart!.image)
//        imageView.contentMode = .scaleAspectFit
        
        // Create the vertical stack view
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // Create the title label
        let titleLabel = UILabel()
        titleLabel.text = currentCart!.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        
        // Create the subtitle label
        let subtitleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        subtitleLabel.text = "Shopping at \(currentCart!.store)"
        subtitleLabel.textColor = .white
        
//        // Add the subviews to the stack views
//        horizontalStackView.addArrangedSubview(imageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        
        return horizontalStackView
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < (currentCart?.memberUIDs?.count)!) {
            let userSubcartCell = tableView.dequeueReusableCell(withIdentifier: "UserCartCell", for: indexPath) as! NestedCartTableViewCell
            
            userSubcartCell.ownerUID = currentCart?.memberUIDs![indexPath.row]
            userSubcartCell.listenForDatabaseUpdates()
            
            // give cell a closure to update this outer table size
            userSubcartCell.updateOuterTableSize = {
                self.cartTable.beginUpdates()
                self.cartTable.endUpdates()
            }
            return userSubcartCell
        } else {
            let addMemberToCartCell = tableView.dequeueReusableCell(withIdentifier: "AddCartMemberCell", for: indexPath) as! AddCartMemberCell
            return addMemberToCartCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentCart?.memberUIDs!.count)! + 1
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func unwindToCartHomeVC(segue: UIStoryboardSegue) {
 
    }
    
    // Listen for cart updates from database. Ex: for member addition/removal.
    func listenForCartDatabaseUpdates() {
        print("listening for db updates")
        let db = Firestore.firestore()
        snapshotListener = db.collection("carts").document(CartScreenVC.currentCartId).addSnapshotListener { docSnapshot, error in
            guard let document = docSnapshot else {
                print("Error fetching document")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("new cart data, setting: \(data)")
            _ = Cart(dbCartData: data, onFinishInit: { cart in
                self.currentCart = cart
                self.cartTable.reloadData()
            })
        }
    }
    
    deinit {
        // Remove listener for cart db updates on deinit.
        if let snapshotListener = snapshotListener {
            snapshotListener.remove()
        }
    }
}
