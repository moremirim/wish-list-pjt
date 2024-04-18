//
//  RemoteProduct.swift
//  wish-list-draft
//
//  Created by 박미림 on 4/14/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int64
    let title: String
    let description: String
    let price: Double
    let stock: Int64
    let thumbnail: URL
    let images: Array<URL>
}

