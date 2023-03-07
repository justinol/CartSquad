//
//  StoreSearchViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 3/4/23.
//

import UIKit

class StoreSearchViewController: UIViewController {
    
    var delegate:UIViewController!
    var searchQuery:String = ""
    var searchDistance:Int = 0
    @IBOutlet weak var searchQueryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchQueryLabel.text = "Search results for \"\(searchQuery)\" within \(searchDistance) mi."
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
