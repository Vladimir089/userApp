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
    func showVC(currentItem: (Dish, UIImage))
    func addToCart(button: UIButton, currentItem: (Dish, UIImage))
    func showCart()
    func closeVC()
    func updateSelectedCategoryButton(with category: String)
    func endScroll()
}

class MainViewController: UIViewController {
    
    var mainView: MainView?
    var isLoad = false
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if orderArr.count != 0 {
            UIView.animate(withDuration: 0.2) {
                self.mainView?.showCartButton?.alpha = 100
            }
        } else {
            mainView?.showCartButton?.alpha = 0
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = MainView()
        mainView?.delegate = self
        self.view = mainView
        
        getDishes {
            self.mainView?.collectionView?.reloadData()
            self.mainView?.settingsScrollView()
    
        }

    }

}

extension MainViewController: MainViewControllerDelegate {
    func endScroll() {
        isLoad = false
    }
    
    func closeVC() {
        if orderArr.count == 0 {
            mainView?.showCartButton?.alpha = 0
            mainView?.showCartButton?.isUserInteractionEnabled = false
        }
        self.mainView?.showCartButton?.setTitle("Корзина \(totalCoast) ₽", for: .normal)
    }
    
    func updateSelectedCategoryButton(with category: String) {
        if isLoad == true {
            return
        }
        
        for subview in mainView?.topCategoriesScrollView?.subviews ?? [] {
            if let button = subview as? UIButton, let buttonText = button.titleLabel?.text {
                button.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
                
                if buttonText == category {
                    UIView.animate(withDuration: 0.3) {
                        button.tintColor = .black
                    }
                    if !mainView!.topCategoriesScrollView!.bounds.contains(button.frame) {
                        mainView!.topCategoriesScrollView!.scrollRectToVisible(button.frame, animated: true)
                    }
                }
            }
        }
    }


    

    
    func showCart() {
        let vc = CartViewController()
        vc.delegate = self
        self.present(vc, animated: true)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func addToCart(button: UIButton, currentItem: (Dish, UIImage)) {
        let originalColor = button.backgroundColor
        let originalColorToText = button.tintColor
        if let existingIndex = orderArr.firstIndex(where: { $0.0 == currentItem.0.name }) {
            orderArr[existingIndex].1 += 1
        } else {
            orderArr.append((currentItem.0.name, 1, currentItem.1, currentItem.0.price))
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
        UIView.animate(withDuration: 0.5) {
            self.mainView?.showCartButton?.alpha = 100
            self.mainView?.showCartButton?.isUserInteractionEnabled = true
        }
        getTotalCoast(adress: adress) {
            self.mainView?.showCartButton?.setTitle("Корзина \(totalCoast) ₽", for: .normal)
        }
        
    }
    
    func showVC(currentItem: (Dish, UIImage)) {
        let vc = DetailViewController()
        vc.delegate = self
        vc.index = currentItem
        let exitArr: [(Dish, UIImage)] = []
        vc.categoryArr = mainView?.categoryArr ?? exitArr
        self.present(vc, animated: true)
    }
    
    
    func reloadTable(category: String) {
        isLoad = true
        for subview in mainView?.topCategoriesScrollView?.subviews ?? [] {
            if let button = subview as? UIButton, let buttonText = button.titleLabel?.text {
                // Устанавливаем цвет по умолчанию для всех кнопок
                button.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
                
                if buttonText == category {
                    // Анимируем изменение цвета только для выбранной категории
                    UIView.animate(withDuration: 0.3) {
                        button.tintColor = .black
                    }
                }
            }
        }
        if let sectionIndex = mainView?.cleanCategoryArr.firstIndex(of: category) {
            if sectionIndex < mainView?.collectionView?.numberOfSections ?? 0 {
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                mainView?.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
    

}
