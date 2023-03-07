//
//  Store.swift
//  CartSquad
//
//  Created by Justin Lee on 3/5/23.
//

import UIKit

class Store {
    let storeName:String
    let storeAddress:String
    let storeImage:UIImage
    
    init(name:String, address:String, image:UIImage) {
        storeName = name
        storeAddress = address
        storeImage = image
    }
}
