//
//  ProductModel.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/4/23.
//

import Foundation

struct ProductModel: Decodable {
    let id: Int
    let name: String
    let image_url: String
    let features: [String]
    let price: String
}
