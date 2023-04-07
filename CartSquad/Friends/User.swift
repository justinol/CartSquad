//
//  User.swift
//  CartSquad
//
//  Created by Justin Lee on 4/6/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class User: NSObject {
    
    var name: String?
    var userName: String?
    var image: UIImage?
    var imageURL: String?
    
    init(name: String?, userName: String?, image: UIImage? = nil, imageURL: String? = nil) {
        super.init()
        self.name = name
        self.userName = userName
        self.image = image
        self.imageURL = imageURL
    }
}
