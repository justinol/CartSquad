//
//  Cart.swift
//  CartSquad
//
//  Created by Justin Lee on 3/6/23.
//

import Foundation
import UIKit

class Cart {
    var name:String
    var image:UIImage
    var store:String
    var date:String
    
    init(name:String, image:UIImage, store:String, date:String){
        self.name = name
        self.image = image
        self.store = store
        self.date = date
    }
}
