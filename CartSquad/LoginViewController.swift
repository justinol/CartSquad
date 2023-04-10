//
//  LoginViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 3/3/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    let segueIdentifier = "mainMenuSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self
        passwordText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //segue unwinds to the login view controller.
    @IBAction func unwindToLogin(_ seg: UIStoryboardSegue) {
        
    }
    
    //When the login button is pressed, the email and password information is passed
    // into the firebase authentication system and segues into the main menu.
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text else{
            print("Please enter email or password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {firebaseResult, error in
            if let error = error  {
                print("error signing in \(error.localizedDescription)")
                return
            }
            
            self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
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
