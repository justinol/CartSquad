//
//  PeronalInfoViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 3/5/23.
//

/*
 @IBOutlet weak var address1: UITextField!
 @IBOutlet weak var address2: UITextField!
 @IBOutlet weak var city: UITextField!
 @IBOutlet weak var state: UITextField!
 @IBOutlet weak var zip: UITextField!
 @IBOutlet weak var nameText: UITextField!
 
 */

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PeronalInfoViewController: UIViewController {

    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    let segueIdentifier = "goToMain"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //unwind to the personal info view controller. To be continued in beta
    //@IBAction func unwindToPersonalInfo(_ seg: //UIStoryboardSegue) {
        
    //}
    
    //saves the data into the user collection and then segues to the main screen!
    @IBAction func saveButtonPressed(_ sender: Any) {
        let userCollection = Firestore.firestore().collection("users")
        userCollection.document(Auth.auth().currentUser!.uid).updateData([
            "Name" : nameText.text!,
            "address 1" : address1.text!,
            "address 2" : address2.text!,
            "city" : city.text!,
            "state" : state.text!,
            "zip" : zip.text!
        ]){(error) in
            if let error = error  {
                print("Error updating document \(error)")
            } else{
                print("some personal informations added!")
            }
        }
        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    

}
