//
//  CreateAccountViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 3/3/23.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createEmailText: UITextField!
    @IBOutlet weak var createUsernameText: UITextField!
    @IBOutlet weak var createPasswordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let createEmail = createEmailText.text, let createPass = createPasswordText.text,
             let confirmPass = confirmPassword.text else {
            print("Please enter email, password, or retype password")
            return
        }
        if confirmPass != createPass {
            print("passwords do not match !")
            return
        }
        Auth.auth().createUser(withEmail: createEmail, password: createPass){ firebaseResult ,error in
            if let error = error  {
                print("error creating account \(error.localizedDescription)")
                return
            }
            
            self.performSegue(withIdentifier: "createAccount", sender: self)
            
        }
    }
    
}
