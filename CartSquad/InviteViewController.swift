//
//  InviteViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 3/5/23.
//

import UIKit

class InviteViewController: UIViewController {

    @IBOutlet weak var cartPrivilege: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont.systemFont(ofSize: 20)
        
        cartPrivilege.frame.size.height = 50
        cartPrivilege.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font], for: UIControl.State.selected)
        cartPrivilege.setTitleTextAttributes([ NSAttributedString.Key.font: font], for: UIControl.State.normal)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    @IBAction func onInviteButtonPressed(_ sender: Any) {
        
    }
}
