//
//  NewWorking.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

let cafeID = 2
let token  = "73d2b9b6a303857b5854479692b05bd01defb73fb86fc5350689de1b637b764859b8993cb6b66870b3bac0c933d4d273a2e9d7a1c8ba0eabc0e03d083171c095c3da671d85336cff9e0abe44324489c7188b6c91e74d8043fabaecf6b4df2b0ceeee4e9ba19887b6372e1c4f8e2fe55c2058ffdedd022af452d2dd9db698853a"
var controller: MainViewController?


func getDishes(completion: @escaping (Error?) -> Void) {
    let headers: HTTPHeaders = [
        HTTPHeader.authorization(bearerToken: token)]
    
    AF.request("http://arbamarket.ru/api/v1/main/get_dishes/?cafe_id=\(cafeID)", method: .get, headers: headers).response { response in
        switch response.result {
        case .success(_):
            
            if let status = response.response?.statusCode {
                if status == 502 || status == 400 {
                    let error = NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey : "Bad Gateway"])
                    completion(error)
                    return
                }
            }
            
            if let data = response.data, let dishResponse = try? JSONDecoder().decode(DishesResponse.self, from: data) {
                let dishes = dishResponse.dishes
                
                let group = DispatchGroup()
                
                for dish in dishes {
                    group.enter()
                    getImage(d: dish) {
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        case .failure(let error):
            print("error getDishes")
            completion(error)
        }
    }
}

func getImage(d: Dish, completion: @escaping () -> Void) {
    if let url = d.img {
        AF.request("http://arbamarket.ru\(url)").responseImage { response in
            switch response.result {
            case .success(let image):
                allDishes.append((d, image))
            case .failure(_):
                allDishes.append((d, .standart))
            }
            completion()
        }
    } else {
        completion()
    }
}


func reload(address: String, controller: UIViewController) {
    let headers: HTTPHeaders = [.accept("application/json")]
    AF.request("http://arbamarket.ru/api/v1/main/get_similar_addresses/?value=\(address)", method: .get, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let value):
            guard let json = value as? [String: Any] else {
                print("Invalid JSON format")
                return
            }
            if let value = json["value"] as? String {
                print("Value:", value)
            } else {
                print("Value not found")
            }
            if let fullAddresses = json["full_addresses"] as? [String] {
                if let adresController = controller as? AdresViewController {
                    adresController.adressArr.removeAll()
                    adresController.adressArr = fullAddresses
                    DispatchQueue.main.async {
                        adresController.tableView?.reloadData()
                    }
                }
            } else {
                print("Full addresses not found")
            }
        case .failure(let error):
            print("Request failed with error:", error)
        }
    }
}


var totalCoast = 0
var adressCoast = 0

func getTotalCoast(adress: String?, completion: @escaping () -> Void) {
    let headers: HTTPHeaders = [.accept("application/json")]
    
    var menu = ""
    let lastIndex = orderArr.last?.0

    for (index, key, _, _) in orderArr {
        menu.append("\(index) - \(key)")
        if index != lastIndex {
            menu.append(", ")
        }
    }
    let adresText: String = adress ?? ""
    AF.request("http://arbamarket.ru/api/v1/main/get_total_cost/?menu=\(menu)&address=\(String(describing: adresText))", method: .get, headers: headers).responseJSON { response in
        
        switch response.result {
        case .success(let value):
            if let json = value as? [String: Any] {
                if let totalCost = json["total_cost"] as? Int,
                   let addressCost = json["address_cost"] as? Int {
                    print(totalCost)
                    totalCoast = totalCost
                    adressCoast = addressCost
                    
                    print(adressCoast)
                }
            } else {
                print("Invalid JSON format")
            }
            
        case .failure(let error):
            print("Request failed with error:", error)
        }
        completion()
    }
}


func getStatusOrder(orderId: Int, completion: @escaping () -> Void) {
    let headers: HTTPHeaders = [
        HTTPHeader.authorization(bearerToken: token)]
    
    AF.request("http://arbamarket.ru/api/v1/main/get_status_by_order_id/?order_id=\(orderId)&cafe_id=\(cafeID)", method: .get, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let data):
            if let data = response.data, let stat = try? JSONDecoder().decode(getStatusToOrderStruct.self, from: data) {
                if let statStatus = stat.status {
                    orderID["message"] = statStatus
                    
                }
            }
        case .failure(_):
            print(2)
        }
    }
    completion()
}


struct getStatusToOrderStruct: Codable {
    let status: String?
    let color: String?
}
