//
//  FoodItem.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import Foundation

struct ModelFood : Codable, Hashable {
    
    let id: String
    let title: String
    let image: String
    let description: String
    let weight: String
    let price: Float
    let categoryId: String
    
    
    
    
}
