//
//  PeronalInfoViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 3/5/23.
//

import UIKit

class PeronalInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //unwind to the personal info view controller. To be continued in beta
    @IBAction func unwindToPersonalInfo(_ seg: UIStoryboardSegue) {
        
    }

}
