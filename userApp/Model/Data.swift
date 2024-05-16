//
//  Data.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import Foundation

var orderID = ["orderId": Int(), "date": Date(), "message": "Начинаем готовить Ваш заказ..."] as [String : Any]

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

enum methodButton {
    case plus
    case minus
}


