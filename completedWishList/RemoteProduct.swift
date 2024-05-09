//
//  RemoteProduct.swift
//  completedWishList
//
//  Created by 박미림 on 4/21/24.
//

import Foundation

struct RemoteProduct: Decodable {
    var id: Int
    var title: String
    var description: String
    var price: Int
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String
    var category: String
    var thumbnail: URL
    var images: [String]
}
