//
//  Member.swift
//  CartSquad
//
//  Created by Jose Alonso on 3/5/23.
//

class Member {
    var name = ""
    var username = ""
    var items:[(String, Int)] = []
    var privileges = "Member"
    var budget = -1
    var restrictions:[String] = []
    var addedBy = ""
    
    init(name:String, username:String, items:[(String, Int)]) {
        self.name = name
        self.username = username
        self.items = items
    }
}
