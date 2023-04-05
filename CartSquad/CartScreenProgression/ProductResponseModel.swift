//
//  ProductResponseModel.swift
//  CartSquad
//
//  Created by Alejandro Cisneros on 4/4/23.
//

import Foundation

struct ProductResponseModel: Decodable {
    let products: [ProductModel]
}
