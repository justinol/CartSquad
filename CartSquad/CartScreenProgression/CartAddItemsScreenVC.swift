//
//  CartAddItemsScreenVC.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 3/3/23.
//

import UIKit

class CartAddItemsScreenVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var storeSearchBar: UISearchBar!
    
    let searchEndpoint = "http://3.138.34.17/api/products/search"
    var productResponseData: [ProductModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeSearchBar()
        storeSearchBar.delegate = self
    }
    
    func customizeSearchBar() {
        storeSearchBar.searchBarStyle = .minimal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if storeSearchBar.text == nil {
            return
        }
        
        let searchBarTextWithEncoding = storeSearchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("searched for \(String(describing: searchBarTextWithEncoding))")
        
        guard let completeUrl = URL(string: searchEndpoint + "?searchTerm=" + searchBarTextWithEncoding!) else {
            print("Invalid url \(searchBarTextWithEncoding)")
            return
        }
        
        print("searching at \(completeUrl.absoluteString)")
        var request = URLRequest(url: completeUrl)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error accessing cart squad backend API")
            }
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                print("Error with response, status code: \(String(describing: response))")
                return
            }
            if let data = data {
                do {
                    let productsResponse = try JSONDecoder().decode(ProductResponseModel.self, from: data)
                    self.productResponseData = productsResponse.products
                } catch {
                    print("Error decoding API response")
                }
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toSearchResults", sender: nil)
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResults" {
            if let destinationVC = segue.destination as? CartSearchResultsVC {
                if let productResponseData = productResponseData {
                    destinationVC.products = productResponseData
                }
            }
        }
    }
}
