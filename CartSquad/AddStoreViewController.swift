//
//  AddStoreViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 3/4/23.
//

import UIKit

let target = Store(name: "Target", address: "2025 Guadalupe St STE 01-100, Austin, TX 78705", image: UIImage(named: "targetLogo")!)
var stores:[Store] = [target]


class AddStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchDistanceLabel: UILabel!
    @IBOutlet weak var nearbyStoresTable: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var distance:Int = 50
    var delegate:UIViewController!
    let SearchStoreCellIdentifier = "SearchStoreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyStoresTable.delegate = self
        nearbyStoresTable.dataSource = self
    }
    
    
    @IBAction func onDistanceSlide(_ sender: UISlider) {
        distance = Int(sender.value * 100)
        searchDistanceLabel.text = "\(distance) mi."
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchStoreCellIdentifier, for: indexPath as IndexPath) as! SearchStoreCell
        let row = indexPath.row
        let current = stores[row]
        
        cell.storeName.text = current.storeName
        cell.storeAddress.text = current.storeAddress
        cell.storeImage.image = current.storeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nearbyStoresTable.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let otherVC = delegate as! StoreChanger
        otherVC.changeStore(newStore: stores[row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if (searchTF.text?.isEmpty)! {
            let controller = UIAlertController(
                title: "Missing search",
                message: "Please search for a store:",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
                present(controller, animated: true)
        } else{
            performSegue(withIdentifier: "SearchStoreSegueIdentifier", sender: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchStoreSegueIdentifier", let nextVC = segue.destination as? StoreSearchViewController {
            nextVC.delegate = self
            
            nextVC.searchQuery = searchTF.text!
            nextVC.searchDistance = distance
        }
    }
    

}
