//
//  ViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 2/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    var inviteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onButtonPressed(_ sender: Any) {
        if let sheet = inviteVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        self.present(inviteVC, animated:true)
    }
    
}

