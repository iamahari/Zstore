//
//  ProductDetails.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import Foundation

struct ProductDetails: Codable {
    let category: [Category]?
    let cardOffers: [CardOffer]?
    var products: [Products]?

    enum CodingKeys: String, CodingKey {
        case category,products
        case cardOffers = "card_offers"
    }
}

struct CardOffer: Codable {
    let id, imageURL: String
    let percentage: Double
    let cardName, offerDesc, maxDiscount: String

    enum CodingKeys: String, CodingKey {
        case id, percentage
        case cardName = "card_name"
        case offerDesc = "offer_desc"
        case maxDiscount = "max_discount"
        case imageURL = "image_url"
    }
}

struct Category: Codable {
    let id, name, layout: String?
    var isSelected: Bool? = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.layout = try container.decodeIfPresent(String.self, forKey: .layout)
        self.isSelected = false
    }
}

// MARK: - Product
struct Products: Codable {
    let id, name: String
    let rating: Double
    let reviewCount: Int
    let price: Double
    let categoryID, imageURL, description: String
    let colors: [String]?
    let cardOfferIDS: [String]
//    var isFav = false
   

    enum CodingKeys: String, CodingKey {
        case id, name, rating
        case reviewCount = "review_count"
        case price
        case colors
        case categoryID = "category_id"
        case cardOfferIDS = "card_offer_ids"
        case imageURL = "image_url"
        case description
    }
}
