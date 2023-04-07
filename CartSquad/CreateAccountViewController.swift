//
//  CreateAccountViewController.swift
//  CartSquad
//
//  Created by Angel Nevarez on 3/3/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createEmailText: UITextField!
    @IBOutlet weak var createUsernameText: UITextField!
    @IBOutlet weak var createPasswordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    let segueIdentifier = "createAccount"
    var creatable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //create accounts when button is pressed.
    //segues to the main menu screen.
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let createEmail = createEmailText.text, let createPass = createPasswordText.text,
              let confirmPass = confirmPassword.text, let username = createUsernameText.text else {
            print("Please enter email, username, password, or retype password")
            return
        }
        
        if confirmPass != createPass {
            print("passwords do not match !")
            return
        }
        
        let userCollection = Firestore.firestore().collection("users")
        userCollection.whereField("username", isEqualTo: username).getDocuments{ (querySnapshot, error) in
            if error != nil    {
                print("error getting items")
                return
            }
            if querySnapshot!.documents.count > 0 {
                //username exists
                print("error: username already exists")
                return
            } else {
                //username does not exists
                Auth.auth().createUser(withEmail: createEmail, password: createPass){ firebaseResult ,error in
                    if let error = error  {
                        print("error creating account \(error.localizedDescription)")
                        return
                    }
                    print("right before function")
                    self.segueToPersonalInfo(userCollection: userCollection, username: username)
                }
            }
        }
    }
    
    
    //function that performs the segue and stroes the username in the firestore database
    func segueToPersonalInfo(userCollection : CollectionReference, username : String) {
        print("in function")
        userCollection.document(Auth.auth().currentUser!.uid).setData([
            "username" : username
        ])
        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
}
