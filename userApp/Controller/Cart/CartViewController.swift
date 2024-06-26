//
//  CartViewController.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit
import Alamofire

var orderArr = [(String, Int, UIImage, Int)]()
var idd = 0
 
protocol CartViewControllerDelegate: AnyObject {
    func showAdresVC()
    func closeVC(text: String)
    func stepperPlusMinus(method: methodButton, index: Int)
    func reloadLabels(adress: String)
    func createNewOrder(phonee: String, menuItems: String, clientsNumber: Int, adress: String, totalCost: Int, paymentMethod: String, timeOrder: String, cafeID: Int, completion: @escaping (Bool) -> Void)
    func clearAdressText()
    func deinitSelfVC()
}

class CartViewController: UIViewController {
    
    var mainView: CartView?
    weak var delegate: MainViewControllerDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.closeVC()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = CartView()
        mainView?.delegate = self
        self.view = mainView
        settingsNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func settingsNavBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Корзина"
        navigationController?.navigationBar.backItem?.title = ""
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.2) {
                self.mainView?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.mainView?.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension CartViewController: CartViewControllerDelegate {
    func deinitSelfVC() {
        self.delegate?.startStatus()
        self.dismiss(animated: true)
    }
    
    func clearAdressText() {
        mainView?.adresTextField?.text = nil
    }
    
    func createNewOrder(phonee: String, menuItems: String, clientsNumber: Int, adress: String, totalCost: Int, paymentMethod: String, timeOrder: String, cafeID: Int, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            HTTPHeader.accept("application/json"),
            HTTPHeader.contentType("application/json"),
            HTTPHeader.authorization(bearerToken: token)
        ]
        
        var phone = phonee
        if phone.hasPrefix("+7") {
            phone.removeFirst(2)
        } else if phone.hasPrefix("8") {
            phone.removeFirst()
        }

        let parameters: [String : Any] = [
            "phone": phone,
            "menu_items": menuItems,
            "clients_number": clientsNumber,
            "address": adress,
            "total_cost": totalCoast,
            "payment_method": "Наличка",
            //"order_on_time": timeOrder,  // к определенному времени
            "cafe_id": cafeID
        ]
        
        AF.request("http://arbamarket.ru/api/v1/main/create_order/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data as? [String: Any] {
                    if let orderId = jsonData["order_id"] as? Int {
                        idd = orderId
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func reloadLabels(adress: String) {
        getTotalCoast(adress: adress) {
            self.mainView?.deliveryOrderLabel?.text = "\(adressCoast) ₽"
            self.mainView?.summLabel?.text = "\(totalCoast) ₽"
        }
    }
    
    func stepperPlusMinus(method: methodButton, index: Int) {
        switch method {
        case .minus:
            orderArr[index].1 -= 1

            if orderArr[index].1 >= 1 && orderArr[index].1 != 0  {
                mainView?.collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
            
            if orderArr[index].1 == 0 {
                orderArr.remove(at: index)
                mainView?.collectionView?.performBatchUpdates({
                    mainView?.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
                }, completion: { _ in
                    for i in index..<orderArr.count {
                        let updatedIndexPath = IndexPath(item: i, section: 0)
                        self.mainView?.collectionView?.reloadItems(at: [updatedIndexPath])
                    }
                })
            }
        case .plus:
            if orderArr[index].1 < 10 {
                orderArr[index].1 += 1
                mainView?.collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        getTotalCoast(adress: adress) {
            self.mainView?.deliveryOrderLabel?.text = "\(adressCoast) ₽"
            self.mainView?.summLabel?.text = "\(totalCoast) ₽"
            self.mainView?.createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
        }
        mainView?.updateLabels()
    }
    
    func closeVC(text: String) {
        mainView?.adresTextField?.text = text
        mainView?.adresTextField?.reloadInputViews()
        getTotalCoast(adress: adress) {
            self.mainView?.deliveryOrderLabel?.text = "\(adressCoast) ₽"
            self.mainView?.summLabel?.text = "\(totalCoast) ₽"
            self.mainView?.createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
        }
    }
    
    func showAdresVC() {
        let vc = AdresViewController()
        vc.delegate = self
        adress = mainView?.adresTextField?.text ?? ""
        self.present(vc, animated: true)
    }
    

    
}
