//
//  MainView.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    var segmentedControl: UISegmentedControl?
    var topCategoriesScrollView: UIScrollView?
    var delegate: MainViewControllerDelegate?
    var activeButton, showCartButton: UIButton?
    var collectionView: UICollectionView?
    var categoryArr: [(Dish, UIImage)] = []
    var cleanCategoryArr = [String]()
    var isScrolling: Bool = false
    var errorView: UIView?
    var standartView: UIView?
    var blurView: UIView?
    var oneViewForBot, twoViewForBot, threeViewForBot: UIImageView?
    var blurViewFirst: UIView?


    
    //MARK: -Init

    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        createElement()
        createError()
        if let adresKey = UserDefaults.standard.string(forKey: "adressKey")  {
            adress = adresKey
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Set elements
    func createError() {
        
        standartView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        addSubview(standartView ?? UIView())
        standartView?.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalToSuperview()
        })
        
        let modulationScrollView = generateView(colorView: .backElement, cornerRadius: 20)
        standartView?.addSubview(modulationScrollView)
        modulationScrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(42)
        }
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.spacing = 20
            stack.axis = .vertical
            stack.distribution = .fillEqually
            return stack
        }()
        standartView?.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(15)
            make.top.equalTo(modulationScrollView.snp.bottom).inset(-20)
        }
        
        let oneView = generateView(colorView: .backElement, cornerRadius: 20)
        stackView.addArrangedSubview(oneView)
        let twoView = generateView(colorView: .backElement, cornerRadius: 20)
        stackView.addArrangedSubview(twoView)
        let threeView = generateView(colorView: .backElement, cornerRadius: 20)
        stackView.addArrangedSubview(threeView)
        let fourView = generateView(colorView: .backElement, cornerRadius: 20)
        stackView.addArrangedSubview(fourView)
        
        errorView = {
            let view = UIView()
            view.backgroundColor = .white
            view.alpha = 0
            return view
        }()
        addSubview(errorView ?? UIView())
        errorView?.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalToSuperview()
        })
        let imageView = UIImageView()
        let image: UIImage = .error
        imageView.image = image
        errorView?.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(160)
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
        }
        
        let labelMain: UILabel = {
            let label = UILabel()
            label.text = "Нет соединения с сервером"
            label.font = .systemFont(ofSize: 25, weight: .semibold)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        errorView?.addSubview(labelMain)
        labelMain.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-10)
        }
        
        let secondLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1)
            label.numberOfLines = 3
            label.textAlignment = .center
            label.text = "В настоящее время подключение к серверу недоступно, повторите попытку."
            return label
        }()
        errorView?.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelMain.snp.bottom).inset(-10)
        }
        
        let refreshButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Попробовать снова", for: .normal)
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.tintColor = .white
            button.layer.cornerRadius = 30
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
            return button
        }()
        errorView?.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(secondLabel.snp.bottom).inset(-30)
        }
    }
    
    func generateView(colorView: UIColor, cornerRadius: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = colorView
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    func error(isError: Bool) {
        switch isError {
        case true:
            errorView?.alpha = 100
            standartView?.alpha = 0
        case false:
            errorView?.alpha = 0
            standartView?.alpha = 0
            collectionView?.reloadData()
            settingsScrollView()
        }
    }
    
    @objc func refresh() {
        delegate?.refreshView()
    }
    
    
    
    func createElement() {
        
        
        topCategoriesScrollView = {
            let scroll = UIScrollView()
            scroll.showsVerticalScrollIndicator = false
            scroll.showsHorizontalScrollIndicator = false
            scroll.delegate = self
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
            collection.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
            return collection
        }()
        addSubview(collectionView ?? UICollectionView())
        

        blurView = {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(showCart))
            let blurEffect = UIBlurEffect(style: .extraLight)
           // let blurView = UIVisualEffectView(effect: blurEffect)
            let blurView = UIView()
            blurView.layer.cornerRadius = 30
            blurView.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 0.9)
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.clipsToBounds = true
            blurView.addGestureRecognizer(gesture)
            return blurView
        }()
        addSubview(blurView ?? UIView())
        
        showCartButton = {
            let button = UIButton(type: .system)
            button.setTitle("\(totalCoast) ₽", for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(showCart), for: .touchUpInside)
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            return button
        }()
        addSubview(showCartButton ?? UIButton())
        
        
        if let blurEffectView = blurView /*as? UIVisualEffectView*/ {
            
            oneViewForBot = generateImageView()
            //blurEffectView.contentView.addSubview(oneViewForBot ?? UIView())
            blurEffectView.addSubview(oneViewForBot ?? UIView())
            
            twoViewForBot = generateImageView()
            twoViewForBot?.alpha = 0
            //blurEffectView.contentView.addSubview(twoViewForBot ?? UIView())
            blurEffectView.addSubview(twoViewForBot ?? UIView())
            
            threeViewForBot = generateImageView()
            threeViewForBot?.alpha = 0
            //blurEffectView.contentView.addSubview(threeViewForBot ?? UIView())
            blurEffectView.addSubview(threeViewForBot ?? UIView())
        }
    
        
        createConstraints()
    }
    
    //MARK: -Set constraints
    
    func createConstraints() {
        
        
        topCategoriesScrollView?.snp.makeConstraints({ make in
            make.height.equalTo(42)
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        })
        
        collectionView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo((topCategoriesScrollView ?? UIScrollView()).snp.bottom).inset(-5)
        })
//        blurViewFirst?.snp.makeConstraints({ make in
//            make.width.equalTo(180)
//            make.height.equalTo(60)
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(1225)
//        })
        
        blurView?.snp.makeConstraints({ make in
            make.width.equalTo(180)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(25)
        })
        
        showCartButton?.snp.makeConstraints({ make in
            make.top.bottom.equalTo((blurView ?? UIView()))
            make.left.equalTo((blurView ?? UIView())).inset(35)
        })
        
        oneViewForBot?.snp.makeConstraints({ make in
            make.height.width.equalTo(58)
            make.right.equalToSuperview().inset(2)
            make.centerY.equalToSuperview()
        })
        
        twoViewForBot?.snp.makeConstraints({ make in
            make.height.width.equalTo(58)
            make.right.equalTo((oneViewForBot?.snp.left)!).inset(25)
            make.centerY.equalToSuperview()
        })
        
        threeViewForBot?.snp.makeConstraints({ make in
            make.height.width.equalTo(58)
            make.right.equalTo((twoViewForBot?.snp.left)!).inset(25)
            make.centerY.equalToSuperview()
        })
        
        
    }
    
    func generateImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
        imageView.layer.cornerRadius = 29
        imageView.clipsToBounds = true
        return imageView
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

        for i in allDishes {
           categoryArr.append(i)
            print(i)
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
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            button.setTitleColor(UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1), for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.layer.cornerRadius = 15
            tag += 1
            let buttonWidth = button.intrinsicContentSize.width
            totalWidth += buttonWidth + buttonSpacing
            button.addTarget(self, action: #selector(changeCategory(button: )), for: .touchUpInside)
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
        collectionView?.reloadData()
        topCategoriesScrollView?.contentSize = CGSize(width: totalWidth, height: 42)
    }
    
    
    @objc func changeCategory(button: UIButton) {
        activeButton?.setTitleColor(UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1), for: .normal)
        activeButton?.isUserInteractionEnabled = true
        activeButton?.backgroundColor = .white
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)


        
        activeButton = button
        let text: String = button.titleLabel?.text ?? ""
        delegate?.reloadTable(category: text)
    }
    
    @objc func showCart() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        delegate?.showCart()
    }
    
}

extension MainView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           if scrollView == collectionView {
               isScrolling = true
           }
       }

       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           if scrollView == collectionView {
               isScrolling = false
           }
       }
}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // Вы можете установить здесь желаемую высоту заголовка
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard collectionView == self.collectionView else { return }
        let section = indexPath.section
        let category = cleanCategoryArr[section]
        delegate?.updateSelectedCategoryButton(with: category)
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.endScroll()
       }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath) as? SectionHeaderView else {
            fatalError("Failed to dequeue SectionHeaderView")
        }
        headerView.titleLabel.text = cleanCategoryArr[indexPath.section]
        return headerView
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cleanCategoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = cleanCategoryArr[section]
        print(category)
        print(categoryArr.filter { $0.0.category == "\(section + 1). \(category)" }.count)
        return categoryArr.filter { $0.0.category == "\(section + 1). \(category)" }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let category = cleanCategoryArr[indexPath.section]
        let itemsInSection = categoryArr.filter { $0.0.category == "\(indexPath.section + 1). \(category)" }
        let currentItem = itemsInSection[indexPath.row]
        
        let imageView: UIImageView = {
            let image = currentItem.1
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
            label.text = currentItem.0.name
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
            button.setTitle("\(currentItem.0.price) ₽", for: .normal)
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
        guard let collectionView = collectionView,
              let indexPath = collectionView.indexPathForItem(at: collectionView.convert(button.center, from: button.superview)) else {
            return
        }
        
        let section = indexPath.section
        let row = indexPath.row
        
        let category = cleanCategoryArr[section]
        let itemsInSection = categoryArr.filter { $0.0.category == "\(section + 1). \(category)" }
        let currentItem = itemsInSection[row]
        print(currentItem)
        delegate?.addToCart(button: button, currentItem: currentItem)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = cleanCategoryArr[indexPath.section]
        let itemsInSection = categoryArr.filter { $0.0.category == "\(indexPath.section + 1). \(category)" }
        let currentItem = itemsInSection[indexPath.row]
        delegate?.showVC(currentItem: currentItem)
    }
    
    
}





