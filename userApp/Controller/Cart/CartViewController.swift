//
//  CartViewController.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit
 
protocol CartViewControllerDelegate: AnyObject {
    func showAdresVC()
    func closeVC(text: String)
}

class CartViewController: UIViewController {
    
    var mainView: CartView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = CartView()
        mainView?.delegate = self
        self.view = mainView
        settingsNavBar()
        
    }
    
    func settingsNavBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Корзина"
        navigationController?.navigationBar.backItem?.title = ""
    }
    
}

extension CartViewController: CartViewControllerDelegate {
    func closeVC(text: String) {
        mainView?.adresTextField?.text = text
        mainView?.adresTextField?.reloadInputViews()
    }
    
    func showAdresVC() {
        let vc = AdresViewController()
        vc.delegate = self
        vc.adress = mainView?.adresTextField?.text ?? ""
        self.present(vc, animated: true)
    }
    
}
