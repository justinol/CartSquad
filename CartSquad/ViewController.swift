//
//  ViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 2/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var splashLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashLabel.text = "Cart Squad"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        AuthUser.userId = usernameField.text == "0" ? 0 : 1
        print("user id:\(AuthUser.userId)")
    }

}

