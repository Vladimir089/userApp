//
//  MainViewController.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit
var allDishes: [(Dish, UIImage)] = []

protocol MainViewControllerDelegate: AnyObject {
    func reloadTable(category: String)
    func showVC(indexPatch: Int)
    func addToCart(button: UIButton)
    func showCart()
}

class MainViewController: UIViewController {
    
    var mainView: MainView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = MainView()
        mainView?.delegate = self
        self.view = mainView
        
        getDishes {
            self.mainView?.settingsScrollView()
        }

    }

}

extension MainViewController: MainViewControllerDelegate {
    
    func showCart() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addToCart(button: UIButton) {
        let originalColor = button.backgroundColor
        let originalColorToText = button.tintColor
        if let existingIndex = orderArr.firstIndex(where: { $0.0 == mainView?.categoryArr[button.tag].0.name }) {
            orderArr[existingIndex].1 += 1
        } else {
            orderArr.append((mainView!.categoryArr[button.tag].0.name, 1))
        }
        
        UIView.animate(withDuration: 0.4) {
            button.tintColor = .white
            button.backgroundColor = .systemGreen
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.4) {
                button.tintColor = originalColorToText
                button.backgroundColor = originalColor
            }
        }
        print(orderArr)
    }
    
    func showVC(indexPatch: Int) {
        let vc = DetailViewController()
        vc.delegate = self
        vc.index = indexPatch
        let exitArr: [(Dish, UIImage)] = []
        vc.categoryArr = mainView?.categoryArr ?? exitArr
        self.present(vc, animated: true)
    }
    
    
    func reloadTable(category: String) { 
        mainView?.categoryArr.removeAll()
        for i in allDishes {
            if i.0.category == category {
                mainView?.categoryArr.append(i)
            }
        }
        mainView?.collectionView?.reloadData()
    }
}
