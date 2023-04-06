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
    
    static var currentCart:Cart?
    var onCartChangedUpdateMainMenu: ((Cart)->())?
    
    var snapshotListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTable.delegate = self
        cartTable.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Custom Navbar
    func createCustomNavBarView(currCart: Cart) {
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
        titleLabel.text = currCart.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        // Create the subtitle label
        let subtitleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        subtitleLabel.text = "Shopping at \(currCart.store)"
        subtitleLabel.textColor = .white

//        // Add the subviews to the stack views
//        horizontalStackView.addArrangedSubview(imageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)


        navigationItem.titleView = horizontalStackView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < (CartScreenVC.currentCart?.memberUIDs.count)!) {
            let userSubcartCell = tableView.dequeueReusableCell(withIdentifier: "UserCartCell", for: indexPath) as! NestedCartTableViewCell
            
            userSubcartCell.ownerUID = CartScreenVC.currentCart?.memberUIDs[indexPath.row]
            userSubcartCell.listenForDatabaseUpdates()
            
            // give cell a closure to update this outer table size
            userSubcartCell.updateOuterTableSize = {
                self.cartTable.beginUpdates()
                self.cartTable.endUpdates()
            }
            userSubcartCell.customInitForUse()
            return userSubcartCell
        } else {
            let addMemberToCartCell = tableView.dequeueReusableCell(withIdentifier: "AddCartMemberCell", for: indexPath) as! AddCartMemberCell
            return addMemberToCartCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (CartScreenVC.currentCart?.cartID == nil) {
            // Cart not finished initializing
            return 0
        }
        return (CartScreenVC.currentCart?.memberUIDs.count)! + 1
    }
    
    // Prevent cell highlighting
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func unwindToCartHomeVC(segue: UIStoryboardSegue) {
 
    }
    
    // Listen for cart updates from database. Ex: for member addition/removal.
    func listenForCartDatabaseUpdates(cartID: String) {
        let db = Firestore.firestore()
        snapshotListener = db.collection("carts").document(cartID).addSnapshotListener { docSnapshot, error in
            guard let document = docSnapshot else {
                print("Error fetching document")
                return
            }
            guard var data = document.data() else {
                print("Document data was empty.")
                let cartDeletedAlert = UIAlertController(title: "Cart Notice", message: "This cart was deleted.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                cartDeletedAlert.addAction(okAction)
                
                self.present(cartDeletedAlert, animated: true)
                return
            }
            
            data["cartId"] = document.documentID
            _ = Cart(dbCartData: data, onFinishInit: { cart in
                CartScreenVC.currentCart = cart
                self.createCustomNavBarView(currCart: cart)
                self.cartTable.reloadData()
                self.onCartChangedUpdateMainMenu!(cart)
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
