//
//  Friend.swift
//  CartSquad
//
//  Created by Jose Alonso on 4/4/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class Friend {
    var id:String = ""
    var username:String = ""
    var name:String = ""
    var imageURL:String = ""
    
    init() {}
    
    // This is what I think it would look like atm...
    static func getFriendsFromDatabase(userID:String, onFinish: @escaping(Friend)->()) {
        print("Getting friends from database...")
        let database = Firestore.firestore()
        let friendsListDbReference = database.collection("users").document(userID).collection("friends")
        
        // Iterate friends to add onto list
        friendsListDbReference.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting friends for user: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    // Each document represents a friendUID I think
                    let friendUID = document.documentID
                    Friend.getFriendFromUID(uid: friendUID, onFinish:onFinish)
                }
            }
        }
    }
    
    // TODO: Make sure database structure actually reflects how we are accessing friend info
    static func getFriendFromUID(uid:String, onFinish: @escaping(Friend)->()) {
        let database = Firestore.firestore()
        let friend = Friend()
        let friendDatabaseRef = database.collection("users").document(uid)
        
        friendDatabaseRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error getting friends for user: \(error.localizedDescription)")
            } else {
                friend.id = uid
                friend.username = documentSnapshot!["username"] as! String
//                friend.imageURL = documentSnapshot!["imageURL"] as! String
                friend.name = documentSnapshot!["name"] as! String
                
                // Send friend to AddFriendsVC Friend List
                onFinish(friend)
            }
        }
    }
}

