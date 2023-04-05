//
//  CartSearchResultsVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/4/23.
//

import UIKit

class CartSearchResultsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var itemAddedToCartPopup: UIView!
    
    let reuseIdentifier = "searchItemCell"
    
    var products: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("making collection for \(products.count)")
        return products.count
    }
    
    func downloadImageForCell(imageURL: String, imageView: UIImageView) {
        // Create a URL from the image URL string
        guard let imageURL = URL(string: imageURL) else {
            print("Invalid image URL")
            return
        }

        // Create a URLSession data task to download the image
        let session = URLSession.shared
        let task = session.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }

            // Check if data contains an image
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }

            // Update UI on the main thread
            DispatchQueue.main.async {
                // Set the downloaded image to the image view
                imageView.image = image
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartSearchItemCollectionViewCell
        let product = products[indexPath.row]
        cell.titleLabel.text = product.name
        cell.priceLabel.text = "$\(product.price) each"
        cell.priceFloat = Float(product.price)
        cell.onAddItemToCart = animateSuccessfulItemAdd
        downloadImageForCell(imageURL: product.image_url, imageView: cell.itemImageView)
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 190, height: 250)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
    func animateSuccessfulItemAdd() {
        self.itemAddedToCartPopup.center.y = 820
        self.itemAddedToCartPopup.isHidden = false
        self.itemAddedToCartPopup.alpha = 0.4
        UIView.animate(withDuration: 1.0, animations:  {
            self.itemAddedToCartPopup.alpha = 1
            self.itemAddedToCartPopup.center.y -= self.view.bounds.width / 8
        }, completion: { finished in
            // Hide popup after 1 second.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1, animations: {
                    self.itemAddedToCartPopup.alpha = 0
                }, completion: { finished in
                    self.itemAddedToCartPopup.isHidden = true
                })
            }
        })
    }
}
