//
//  DetailViewController.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var closeView: UIView?
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var addToCartButton: UIButton?
    
    var index: (Dish, UIImage)?

    var categoryArr: [(Dish, UIImage)] = []
    weak var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
    }
    
    func createInterface() {
        view.backgroundColor = .white
        
        closeView = {
            let view = UIView()
            view.backgroundColor = .backElement
            view.layer.cornerRadius = 2
            return view
        }()
        view.addSubview(closeView ?? UIView())
        
        imageView = {
            let image = index?.1
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            return imageView
        }()
        view.addSubview(imageView ?? UIImageView())
        
        titleLabel = {
            let label = UILabel()
            label.text = index?.0.name
            label.textColor = .black
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 27, weight: .semibold)
            label.numberOfLines = 0
            return label
        }()
        view.addSubview(titleLabel ?? UILabel())
        
        addToCartButton = {
            let button = UIButton(type: .system)
            let text: Int = index?.0.price ?? 0
            button.setTitle("В козину за \(text) ₽", for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
            button.layer.cornerRadius = 30
            button.addTarget(self, action: #selector(add), for: .touchUpInside)
            return button
        }()
        view.addSubview(addToCartButton ?? UIButton())
        
        createConstraints()
    }
    
    func createConstraints() {
        closeView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(4)
        })
        
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo((closeView ?? UIView()).snp.bottom).inset(-15)
            make.height.equalTo((imageView ?? UIView()).snp.width)
        })
        
        titleLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo((imageView ?? UIImageView()).snp.bottom).inset(-10)
        })
        
        addToCartButton?.snp.makeConstraints({ make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    @objc func add() {
        delegate?.addToCart(button: addToCartButton ?? UIButton(), currentItem: index!)
    }

}
