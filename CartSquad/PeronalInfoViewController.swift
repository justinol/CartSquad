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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToPersonalInfo(_ seg: UIStoryboardSegue) {
        
    }

}
