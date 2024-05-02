//
//  Data.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import Foundation

var orderArr = [(String, Int)]()

struct Dish: Codable {
    let id: Int
    let name: String
    let category: String
    let price: Int
    let img: String?
}

struct DishesResponse: Codable {
    let dishes: [Dish]
}
