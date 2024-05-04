//
//  MainView.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    var profileButton: UIButton?
    var segmentedControl: UISegmentedControl?
    var topCategoriesScrollView: UIScrollView?
    var delegate: MainViewControllerDelegate?
    var activeButton, showCartButton: UIButton?
    var collectionView: UICollectionView?
    var categoryArr: [(Dish, UIImage)] = []
    var cleanCategoryArr = [String]()

    
    //MARK: -Init

    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        createElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Set elements
    
    func createElement() {
        profileButton = {
            let button = UIButton(type: .system)
            button.setImage(.personFill, for: .normal)
            button.backgroundColor = .backElement
            button.tintColor = .black
            button.layer.cornerRadius = 10
            return button
        }()
        addSubview(profileButton ?? UIButton())
        
        segmentedControl = {
            let items = ["Доставка", "В кафе"]
            let segmented = UISegmentedControl(items: items)
            segmented.selectedSegmentIndex = 0
            segmented.tintColor = UIColor.backElement
            segmented.selectedSegmentTintColor = .backElement
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
                segmented.setTitleTextAttributes(textAttributes, for: .normal)
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
                segmented.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            return segmented
        }()
        addSubview(segmentedControl ?? UISegmentedControl())
        
        topCategoriesScrollView = {
            let scroll = UIScrollView()
            scroll.showsVerticalScrollIndicator = false
            scroll.showsHorizontalScrollIndicator = false
            return scroll
        }()
        addSubview(topCategoriesScrollView ?? UIScrollView())
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 30
            let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = .white
            collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
            return collection
        }()
        addSubview(collectionView ?? UICollectionView())
        
        showCartButton = {
            let button = UIButton(type: .system)
            button.setTitle("Корзина", for: .normal)
            button.tintColor = .white
            button.alpha = 0
            button.addTarget(self, action: #selector(showCart), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
            button.layer.cornerRadius = 30
            return button
        }()
        addSubview(showCartButton ?? UIButton())
        
        createConstraints()
    }
    
    //MARK: -Set constraints
    
    func createConstraints() {
        profileButton?.snp.makeConstraints({ make in
            make.height.width.equalTo(44)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(5)
        })
        
        segmentedControl?.snp.makeConstraints({ make in
            make.left.equalTo((profileButton ?? UIButton()).snp.right).inset(-15)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.top.equalTo((profileButton ?? UIButton()).snp.top)
        })
        
        topCategoriesScrollView?.snp.makeConstraints({ make in
            make.height.equalTo(42)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((profileButton ?? UIButton()).snp.bottom)
        })
        
        collectionView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo((topCategoriesScrollView ?? UIScrollView()).snp.bottom)
        })
        
        showCartButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        })
        
    }
    
    //MARK: -Settings ScrollView
    
    func settingsScrollView() {
        var tag = 1
        var categories = [String]()
        for dish in allDishes {
            let category = dish.0.category
            if !categories.contains(category) {
                categories.append(category)
            }
        }
        
        var previousButton: UIButton? = nil
        var totalWidth: CGFloat = 0
        let buttonSpacing: CGFloat = 20
        for category in categories {
            let button = UIButton(type: .system)
            let cleanCategory = category.components(separatedBy: ". ").last ?? ""
            button.setTitle(cleanCategory, for: .normal)
            cleanCategoryArr.append(cleanCategory)
            button.tag = tag
            topCategoriesScrollView?.addSubview(button)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            button.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
            tag += 1
            let buttonWidth = button.intrinsicContentSize.width
            totalWidth += buttonWidth + buttonSpacing
            button.addTarget(self, action: #selector(changeCategory(button: )), for: .touchUpInside)
            if previousButton == nil {
                button.tintColor = .black
                activeButton = button
                delegate?.reloadTable(category: "1. Роллы")
                activeButton?.isUserInteractionEnabled = false
            }
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).offset(buttonSpacing)
                } else {
                    make.left.equalToSuperview().inset(10)
                }
                make.width.equalTo(buttonWidth)
            }
            previousButton = button
        }
        topCategoriesScrollView?.contentSize = CGSize(width: totalWidth, height: 42)
    }
    
    
    @objc func changeCategory(button: UIButton) {
        activeButton?.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
        activeButton?.isUserInteractionEnabled = true
        button.tintColor = .black
        button.isUserInteractionEnabled = false
        activeButton = button
        let text: String = button.titleLabel?.text ?? ""
        let category = "\(button.tag). \(text)"
        delegate?.reloadTable(category: category)
    }
    
    @objc func showCart() {
        delegate?.showCart()
    }
    
}


extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categoryArr.count, 23)
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView: UIImageView = {
            let image = categoryArr[indexPath.row].1
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 15
            return imageView
        }()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.left.centerY.equalToSuperview()
        }
      
        let titleText: UILabel = {
            let label = UILabel()
            label.text = categoryArr[indexPath.row].0.name
            label.textColor = .black
            label.numberOfLines = 3
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            return label
        }()
        cell.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().inset(3)
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        let orderButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .backElement
            button.setTitle("\(categoryArr[indexPath.row].0.price) ₽", for: .normal)
            button.tintColor = .black
            button.layer.cornerRadius = 15
            button.tag = indexPath.row
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            button.addTarget(self, action: #selector(addToCart(button:)), for: .touchUpInside)
            return button
        }()
        cell.addSubview(orderButton)
        orderButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.left.equalTo(titleText.snp.left)
            make.bottom.equalToSuperview().inset(3)
        }
        
        
        
        return cell
    }
    
    @objc func addToCart(button: UIButton) {
        delegate?.addToCart(button: button)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showVC(indexPatch: indexPath.row)
    }
    
    
}
