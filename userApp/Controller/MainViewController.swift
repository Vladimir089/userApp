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
    func refreshView()
}

class MainViewController: UIViewController {
    
    var mainView: MainView?
    var isLoad = false
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var prevButton: UIButton?
    
    
    
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
        refreshView()
    }
}

extension MainViewController: MainViewControllerDelegate {
    func refreshView() {
        getDishes { error in
            if error == nil {
                self.mainView?.error(isError: false)
            } else {
                self.mainView?.error(isError: true)
            }
        }
    }
    
    func endScroll() {
        isLoad = false
    }
    
    func updateButton() {
        var summ = 0
        for i in orderArr {
            summ += (i.1 * i.3)
        }
        self.mainView?.showCartButton?.setTitle("Корзина \(summ) ₽", for: .normal)
    }
    
    func closeVC() {
        if orderArr.count == 0 {
            mainView?.showCartButton?.alpha = 0
            mainView?.showCartButton?.isUserInteractionEnabled = false
        }
        updateButton()
    }
    
    func updateSelectedCategoryButton(with category: String) {
        if isLoad == true {
            return
        }
        for subview in mainView?.topCategoriesScrollView?.subviews ?? [] {
            if let button = subview as? UIButton, let buttonText = button.titleLabel?.text {
                if buttonText == category {
                    print(category)
                    prevButton = button
                    if button.titleColor(for: .normal) != .white {
                        UIView.animate(withDuration: 0.3) {
                            button.setTitleColor(.white, for: .normal)
                            button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
                        }
                    }
                    if let scrollView = mainView!.topCategoriesScrollView {
                        let buttonFrameInScrollView = button.frame
                        let contentOffsetX = buttonFrameInScrollView.midX - scrollView.bounds.width / 2.0
                        let centeredRect = CGRect(x: contentOffsetX, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                        scrollView.scrollRectToVisible(centeredRect, animated: true)
                    }
                } else {
                    button.setTitleColor(UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1), for: .normal)
                    button.backgroundColor = .white
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
        
        updateButton()

        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        getTotalCoast(adress: adress) {
            return
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
                button.setTitleColor(UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1), for: .normal)
                button.backgroundColor = .white
                if buttonText == category {
                    UIView.animate(withDuration: 0.3) {
                        button.setTitleColor(.white, for: .normal)
                        button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
                    }
                    
                    if let scrollView = mainView!.topCategoriesScrollView {
                        let buttonFrameInScrollView = button.frame
                        let contentOffsetX = buttonFrameInScrollView.midX - scrollView.bounds.width / 2.0
                        let centeredRect = CGRect(x: contentOffsetX, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                        scrollView.scrollRectToVisible(centeredRect, animated: true)
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
