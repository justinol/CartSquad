//
//  FriendsViewController.swift
//  CartSquad
//
//  Created by Justin Lee on 4/5/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var snapshotListener: ListenerRegistration?
    var friendsListener: ListenerRegistration?
    
    var users:[String:Dictionary<String, Any>] = [:]
    var userList:[(String, Dictionary<String, Any>)] = []
    
    var friends:[String:Dictionary<String, Any>] = [:]
    var friendList:[(String, Dictionary<String, Any>)] = []
    
    var dataSource:[[(String, Dictionary<String, Any>)]] = [[], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        initializeUsers{ (success) -> Void in
            if success {
                self.updateUsersData()
                self.initializeFriends(updateData: self.updateFriendsData)
            }
        }
        
        listenForUsersDatabaseUpdates()
        listenForFriendsDatabaseUpdates()
    }
    

    @IBAction func searchTFChanged(_ sender: UITextField) {
        let querytext = searchTF.text!
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: querytext)
            .whereField("username", isLessThanOrEqualTo: querytext + "~")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.users = [:]
                    for document in querySnapshot!.documents {
                        self.users[document.documentID] = document.data()
                    }
                    self.updateUsersData()
                }
        }
    }
    
    func initializeUsers(completion: @escaping(_ success: Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.users[document.documentID] = document.data()
                }
                completion(true)
            }
        }
    }
    
    func initializeFriends(updateData: @escaping()->()) {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userRef = db.collection("users").document(document.documentID)
                    userRef.getDocument { (userDoc, error) in
                        if let userDoc = userDoc, userDoc.exists {
                            self.friends[document.documentID] = userDoc.data()
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                updateData()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Friends"
        }
        else {
            return "More Users"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath as IndexPath) as! FriendTableViewCell
            let friendData = dataSource[section][row].1
            cell.nameLabel.text = friendData["name"] as? String
            cell.userLabel.text = friendData["username"] as? String
            cell.uid = dataSource[section][row].0
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath as IndexPath) as! UserTableViewCell
            let userData = dataSource[section][row].1
            cell.nameLabel.text = userData["name"] as? String
            cell.userLabel.text = userData["username"] as? String
            cell.uid = dataSource[section][row].0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func listenForUsersDatabaseUpdates() {
        print("listening for users updates")
        let db = Firestore.firestore()
        snapshotListener = db.collection("users").addSnapshotListener {
            querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                let uid = diff.document.documentID
                if diff.type == .removed {
                    self.users[uid] = nil
                } else {
                    self.users[uid] = diff.document.data()
                }
                self.updateUsersData()
            }
        }
    }
    
    func listenForFriendsDatabaseUpdates() {
        print("listening for friends updates")
        let db = Firestore.firestore()
        friendsListener = db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").addSnapshotListener {
            querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                let uid = diff.document.documentID
                if diff.type == .removed {
                    self.friends[uid] = nil
                    self.updateFriendsData()
                    
                    let docRef = db.collection("users").document(uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            self.friendRemoved(uid: uid, data: dataDescription!)
                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                    self.friends[uid] = self.users[uid]
                    self.updateFriendsData()
                    self.friendAdded(uid: uid)
                }
            }
        }
    }
    
    func updateUsersData(){
        let temp:[(key:String,values:[String:Any])] = self.users.compactMap({(key:$0, values:$1)})
        self.userList = temp
        self.dataSource[1] = self.userList
        self.tableView.reloadData()
    }
    
    func friendAdded(uid:String){
        self.users[uid] = nil
        updateUsersData()
    }

    func friendRemoved(uid:String, data:Dictionary<String, Any>){
        self.users[uid] = data
        updateUsersData()
    }
    
    func updateFriendsData(){
        let temp:[(key:String,values:[String:Any])] = self.friends.compactMap({(key:$0, values:$1)})
        self.friendList = temp
        self.dataSource[0] = self.friendList
        self.tableView.reloadData()
    }
}
