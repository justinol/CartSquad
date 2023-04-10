//
//  UpdateProfileInfoViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 4/4/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateProfileInfoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var nameField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        address2.delegate = self
        city.delegate = self
        state.delegate = self
        zipcode.delegate = self
        address1.delegate = self

        // Do any additional setup after loading the view.
        let userInfo = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        print(Auth.auth().currentUser!.uid)
        changeText(userInfo: userInfo)
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        let userInfo = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        userInfo.updateData(["Name" : nameText.text!,
            "address 1" : address1.text!,
            "address 2" : address2.text!,
            "city" : city.text!,
            "state" : state.text!,
            "zip" : zipcode.text!,
            "name" : nameText.text!
            ]){(error) in
                 if let error = error  {
                     print("Error updating document \(error)")
                 } else{
                     print("some personal informations added!")
                 }
             }
        changeText(userInfo : userInfo)
    }
    
    func changeText(userInfo : DocumentReference) {
        userInfo.getDocument { (document, error) in
            if let document = document, document.exists  {
                let data = document.data().map(String.init(describing:)) ?? "nil"
                print("document data : \(data)")
                self.nameText.text = document.get("name") as? String
                self.address2.text = document.get("address 2") as? String
                self.city.text = document.get("city") as? String
                self.state.text = document.get("state") as? String
                self.zipcode.text = document.get("zip") as? String
                self.usernameText.text = "@\(document.get("username") as? String ?? "no user")"
                self.address1.text = document.get("address 1") as? String
                self.nameField.text = document.get("name") as? String
            } else {
                print("Error: document does not exist")
            }
        }
    }
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
