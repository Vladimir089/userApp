//
//  CartView.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit

class CartView: UIView {
    var pribori = 1
    var commentInOrder = ""   //КОММЕНТАРИЙК ЗАКАЗУ
    var topView, separatorView: UIView?
    var phoneTextField, adresTextField: UITextField?
    var collectionView: UICollectionView?
    var scrollView = UIScrollView()
    var contentView = UIView()
    var countLabel: UILabel?
    weak var delegate: CartViewControllerDelegate?
    var botSeparatorView: UIView?
    var noTovarInCart: UILabel?
    var closeView: UIView?
    var errorLabel: UILabel?
    var segmentedControl: UISegmentedControl?
    let feedbackGenerator = UINotificationFeedbackGenerator()
    let feedbackGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var botView: UIView?
    var secondSeparatorView, threeSeparatorView: UIView?
    var priboriLabel: UILabel?
    var priboriCountLabel: UILabel?
    var customStepper: UIView?
    var commentInOrderTextField: UITextField?

    
    
    var countOrderLabel, summCountOrderLabel, deliveryOrderLabel, summLabel: UILabel?
    var deliveryLabel, itogLabel: UILabel?
    var createOrderButton: UIButton?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createInterface()
        if let phoneKey = UserDefaults.standard.string(forKey: "phoneKey")  {
            phone = phoneKey
            phoneTextField?.text = phone
        }
        print(adress, phone)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        settingsScroll()
    }
    
    func createInterface() {
        backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 248/255, alpha: 1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(gesture)
        
        segmentedControl = {
            let items = ["Доставка", "В кафе"]
            let segmented = UISegmentedControl(items: items)
            segmented.selectedSegmentIndex = 0
            segmented.tintColor = UIColor.backElement
            segmented.selectedSegmentTintColor = .backElement
            segmented.addTarget(self, action: #selector(changeSegmented), for: .valueChanged)
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
                segmented.setTitleTextAttributes(textAttributes, for: .normal)
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
                segmented.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            return segmented
        }()
        addSubview(segmentedControl ?? UISegmentedControl())
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(contentView)
        
        topView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            return view
        }()
        scrollView.addSubview(topView ?? UIView())
        
        phoneTextField = {
            let textField = UITextField()
            textField.backgroundColor = .clear
            textField.textAlignment = .left
            textField.keyboardType = .phonePad
            
        
            textField.delegate = self
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: placeholderAttributes)
            
            
            textField.layer.cornerRadius = 5
            textField.textColor = .black
            textField.delegate = self
            textField.text = phone
            return textField
        }()
        topView?.addSubview(phoneTextField ?? UITextField())
        
        separatorView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            return view
        }()
        topView?.addSubview(separatorView ?? UIView())
        
        adresTextField = {
            let textField = UITextField()
            textField.backgroundColor = .clear
            textField.textAlignment = .left
            textField.layer.cornerRadius = 5
            textField.placeholder = "Адрес"
            textField.delegate = self
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Адрес", attributes: placeholderAttributes)
            let image: UIImage = .arrow
            let rightView = UIImageView(image: image)
            textField.rightView = rightView
            textField.textColor = .black
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.text = adress
            return textField
        }()

        topView?.addSubview(adresTextField ?? UITextField())
        
        addSubview(scrollView )
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.isScrollEnabled = false
            collection.backgroundColor = .white
            collection.delegate = self
            collection.dataSource = self
            collection.layer.cornerRadius = 10
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        scrollView.addSubview(collectionView ?? UICollectionView())
        
        botView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            return view
        }()
        contentView.addSubview(botView ?? UIView())
        botView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo((collectionView ?? UICollectionView()).snp.bottom).inset(3)
            make.height.equalTo(155)
        })
        
        secondSeparatorView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            return view
        }()
        topView?.addSubview(secondSeparatorView ?? UIView())
        
        priboriLabel = {
            let label = UILabel()
            label.text = "Кол-во приборов"
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.textColor = .black
            return label
        }()
        topView?.addSubview(priboriLabel ?? UIView())
        
        

        threeSeparatorView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            return view
        }()
        topView?.addSubview(threeSeparatorView ?? UIView())
        
        commentInOrderTextField = {
            let textField = UITextField()
            textField.backgroundColor = .clear
            textField.textAlignment = .left
            textField.layer.cornerRadius = 5
            textField.placeholder = "Комментарий к заказу"
            textField.delegate = self
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(.black)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Комментарий к заказу", attributes: placeholderAttributes)
            textField.textColor = .black
            textField.leftViewMode = .always
            return textField
        }()
        topView?.addSubview(commentInOrderTextField ?? UIView())
        
        if !orderArr.isEmpty {
            let topViewInView = UIView()
            topViewInView.backgroundColor = .white
            botView?.addSubview(topViewInView)
            topViewInView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(20)
                make.top.equalToSuperview().inset(-5)
            }
            let countText = createOrderCountLabelText(count: orderArr.count)
            countOrderLabel = createLabel(text: countText, color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(countOrderLabel ?? UILabel())
            
            var summ = 0
            for i in orderArr {
                summ += (i.1 * i.3)
            }
            summCountOrderLabel = createLabel(text: "\(summ) ₽", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(summCountOrderLabel ?? UILabel())
            
            deliveryLabel = createLabel(text: "Доставка", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(deliveryLabel ?? UILabel())
            
            deliveryOrderLabel = createLabel(text: "\(adressCoast) ₽", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(deliveryOrderLabel ?? UILabel())
            
            botSeparatorView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
                return view
            }()
            botView?.addSubview(botSeparatorView ?? UIView())
            
            itogLabel = createLabel(text: "Итого", color: .black, font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(itogLabel ?? UILabel())
            
            summLabel = createLabel(text: "\(totalCoast) ₽", color: .black, font: .systemFont(ofSize: 17, weight: .regular))
            botView?.addSubview(summLabel ?? UILabel())
            
        }
        
        createOrderButton = {
            let button = UIButton(type: .system)
            button.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.layer.cornerRadius = 30
            button.addTarget(self, action: #selector(createOrder), for: .touchUpInside)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
            return button
        }()
        addSubview(createOrderButton ?? UIButton())
        
        noTovarInCart = {
            let label = UILabel()
            label.text = "В корзине нет товаров? Положим туда изюминку!"
            label.alpha = 0
            label.textAlignment = .center
            label.textColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            label.font = .systemFont(ofSize: 28, weight: .semibold)
            label.numberOfLines = 0
            return label
        }()
        addSubview(noTovarInCart ?? UILabel())
        
        closeView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
            view.layer.cornerRadius = 2
            return view
        }()
        addSubview(closeView ?? UIView())
        
        errorLabel = createLabel(text: "Неправильный", color: .systemRed, font: .systemFont(ofSize: 17, weight: .regular))
        errorLabel?.alpha = 0
        addSubview(errorLabel ?? UILabel())
        
        createContraints()
    }
    
    func createContraints() {
        
        segmentedControl?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(30)
            make.height.equalTo(44)
        })
        
        scrollView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo((segmentedControl ?? UIView()).snp.bottom).inset(-15)
        })
        
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(scrollView.frame.height + CGFloat(orderArr.count * 80))
        })
        
        collectionView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(orderArr.count * 80)
            make.top.equalTo(scrollView.snp.top)
        })
        
        topView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(botView!.snp.bottom).inset(-15)
            make.height.equalTo(205)
        })
        
        
        phoneTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        })
        
        separatorView?.snp.makeConstraints({ make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((phoneTextField ?? UIView()).snp.bottom)
        })
        
        adresTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((separatorView ?? UIView()).snp.bottom)
            make.height.equalTo(50)
        })
        
        secondSeparatorView?.snp.makeConstraints({ make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((adresTextField ?? UIView()).snp.bottom)
        })
    
        priboriLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((secondSeparatorView ?? UIView()).snp.bottom)
            make.height.equalTo(50)
        })
        
        customStepper = {
            let view = UIView()
            view.backgroundColor = .backElement
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            return view
        }()
        topView?.addSubview(customStepper ?? UIView())
        
        createStepper()
        
        threeSeparatorView?.snp.makeConstraints({ make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((priboriLabel ?? UIView()).snp.bottom)
        })
        
        commentInOrderTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(threeSeparatorView!.snp.bottom)
            make.height.equalTo(50)
        })
        
       
        
        if orderArr.count != 0 {
            countOrderLabel?.snp.makeConstraints { make in
                make.top.equalTo((collectionView ?? UICollectionView()).snp.bottom).inset(-15)
                make.left.equalTo((collectionView ?? UICollectionView()).snp.left).inset(10)
            }
            
            summCountOrderLabel?.snp.makeConstraints({ make in
                make.centerY.equalTo((countOrderLabel ?? UILabel()).snp.centerY).inset(-30)
                make.right.equalTo((collectionView ?? UICollectionView()).snp.right).inset(10)
            })
            
            deliveryLabel?.snp.makeConstraints({ make in
                make.left.equalTo((collectionView ?? UICollectionView()).snp.left).inset(10)
                make.top.equalTo((summCountOrderLabel ?? UILabel()).snp.bottom).inset(-30)
            })
            
            deliveryOrderLabel?.snp.makeConstraints({ make in
                make.centerY.equalTo((deliveryLabel ?? UILabel()).snp.centerY).inset(-30)
                make.right.equalTo((collectionView ?? UICollectionView()).snp.right).inset(10)
            })
            
            botSeparatorView?.snp.makeConstraints({ make in
                make.left.right.equalTo((collectionView ?? UICollectionView())).inset(10)
                make.height.equalTo(1)
                make.top.equalTo((deliveryOrderLabel ?? UILabel()).snp.bottom).inset(-15)
            })
            
            itogLabel?.snp.makeConstraints({ make in
                make.left.equalTo((collectionView ?? UICollectionView()).snp.left).inset(10)
                make.top.equalTo((deliveryLabel ?? UILabel()).snp.bottom).inset(-30)
            })
            
            summLabel?.snp.makeConstraints({ make in
                make.centerY.equalTo((itogLabel ?? UILabel()).snp.centerY).inset(-30)
                make.right.equalTo((collectionView ?? UICollectionView()).snp.right).inset(10)
            })
            
            createOrderButton?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(60)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            })
            
            errorLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo((createOrderButton ?? UIButton()).snp.top).inset(-10)
            })
            
        }
        
        noTovarInCart?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        })
        
        closeView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(4)
        })
      
    }
    
    
    
    
    
    func createStepper() {
        customStepper?.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(103)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo((priboriLabel ?? UIView()))
        }
        let minusButton = createStepperButton(image: .minus)
        minusButton.addTarget(self, action: #selector(priborMinus), for: .touchUpInside)
        customStepper?.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(10)
        }
        
        let plusButton = createStepperButton(image: .plus)
        plusButton.addTarget(self, action: #selector(priborPlus), for: .touchUpInside)
        customStepper?.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(10)
        }
        
        priboriCountLabel = {
            let label = UILabel()
            label.textColor = .black
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.text = "\(pribori)"
            return label
        }()
        
        customStepper?.addSubview(priboriCountLabel ?? UILabel())
        priboriCountLabel?.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
    }
    
    @objc func changeSegmented() {
        feedbackGeneratorMedium.prepare()
        feedbackGeneratorMedium.impactOccurred()
    }
    
    @objc func priborMinus() {
        if pribori > 1 {
            pribori -= 1
        }
        priboriCountLabel?.text = "\(pribori)"
    }
    
    @objc func priborPlus() {
        if pribori < 10 {
            pribori += 1
        }
        priboriCountLabel?.text = "\(pribori)"
    }
    
    @objc func createOrder() {
        
        if phoneTextField?.text?.count ?? 0 < 10 {
            createOrderButton?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [self] in
                createOrderButton?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                createOrderButton?.setTitle("Неверный номер телефона 😢", for: .normal)
                self.createOrderButton?.backgroundColor = .systemRed
            },
                           completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.createOrderButton?.transform = CGAffineTransform.identity
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.createOrderButton?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
                    self.createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
                    self.createOrderButton?.isUserInteractionEnabled = true
                }
            })
            self.feedbackGenerator.prepare()
            self.feedbackGenerator.notificationOccurred(.error)
            
            return
        }
        
        if adresTextField?.text == "" || adresTextField?.text == " " || adresTextField?.text == nil {
            createOrderButton?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [self] in
                createOrderButton?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                createOrderButton?.setTitle("Неверный адрес 😢", for: .normal)
                self.createOrderButton?.backgroundColor = .systemRed
            },
                           completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.createOrderButton?.transform = CGAffineTransform.identity
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.createOrderButton?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
                    self.createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
                    self.createOrderButton?.isUserInteractionEnabled = true
                }
            })
            self.feedbackGenerator.prepare()
            self.feedbackGenerator.notificationOccurred(.error)
            return
        }
        
        var menu = ""
        let lastIndex = orderArr.last?.0

        for (index, key, _, _) in orderArr {
            menu.append("\(index) - \(key)")
            if index != lastIndex {
                menu.append(", ")
            }
        }
        delegate?.createNewOrder(phonee: phone, menuItems: menu, clientsNumber: pribori, adress: adress, totalCost: totalCoast, paymentMethod: "Наличка", timeOrder: "1", cafeID: 2, completion: { success in
            if success {
                UserDefaults.standard.setValue(phone, forKey: "phoneKey")
                UserDefaults.standard.setValue(adress, forKey: "adressKey")
                UIView.animate(withDuration: 0.5) { [self] in
                    createOrderButton?.setTitle("Заказ успешно создан!", for: .normal)
                    createOrderButton?.backgroundColor = .systemGreen
                    createOrderButton?.isUserInteractionEnabled = false
                    orderArr.removeAll()
                    totalCoast = 0
                }
                self.feedbackGenerator.prepare()
                self.feedbackGenerator.notificationOccurred(.success)
            } else {
                self.createOrderButton?.isUserInteractionEnabled = false
                self.feedbackGenerator.prepare()
                self.feedbackGenerator.notificationOccurred(.error)
                UIView.animate(withDuration: 0.1,
                               delay: 0,
                               usingSpringWithDamping: 0.2,
                               initialSpringVelocity: 6.0,
                               options: .allowUserInteraction,
                               animations: { [self] in
                    createOrderButton?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    createOrderButton?.setTitle("Нет интернет соединения", for: .normal)
                    self.createOrderButton?.backgroundColor = .systemRed
                },
                               completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.createOrderButton?.transform = CGAffineTransform.identity
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.createOrderButton?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
                        self.createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
                        self.createOrderButton?.isUserInteractionEnabled = true
                    }
                })
            }
        })
    }
    
    func updateLabels() {
        settingsScroll()
        countOrderLabel?.text = createOrderCountLabelText(count: orderArr.count)
        
        var summ = 0
        for i in orderArr {
            summ += (i.1 * i.3)
        }
        summCountOrderLabel?.text = "\(summ) ₽"
        deliveryOrderLabel?.text = "\(adressCoast) ₽"
        createOrderButton?.setTitle("Оформить заказ за \(totalCoast) ₽", for: .normal)
        
        if orderArr.count == 0 {
            UIView.animate(withDuration: 0.2) { [self] in
                scrollView.alpha = 0
                scrollView.isUserInteractionEnabled = false
                createOrderButton?.alpha = 0
                createOrderButton?.isUserInteractionEnabled = false
                noTovarInCart?.alpha = 100
            }
            
        }
    }
    
    func createLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.text = text
        return label
    }
    
    func createOrderCountLabelText(count: Int) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        let index = (count % 100 > 4 && count % 100 < 20) ? 2 : cases[min(count % 10, 5)]
        switch index {
        case 0:
            return "\(count) товар"
        case 1:
            return "\(count) товара"
        default:
            return "\(count) товаров"
        }
    }
    func settingsScroll() {
        UIView.animate(withDuration: 0.5) { [self] in
            contentView.isUserInteractionEnabled = true
            contentView.snp.updateConstraints({ make in
                make.height.equalTo(450 + CGFloat(orderArr.count * 80))
            })
            collectionView?.snp.updateConstraints({ make in
                make.height.equalTo(orderArr.count * 80)
            })
            self.layoutIfNeeded()
        }
    }

    
    @objc func stepperMinus(button: UIButton) {
        feedbackGeneratorMedium.prepare()
        feedbackGeneratorMedium.impactOccurred()
        delegate?.stepperPlusMinus(method: .minus, index: button.tag)
    }
    
    @objc func stepperPlus(button: UIButton) {
        feedbackGeneratorMedium.prepare()
        feedbackGeneratorMedium.impactOccurred()
        delegate?.stepperPlusMinus(method: .plus, index: button.tag)
    }
    
    @objc func hideKeyboard() {
        phoneTextField?.resignFirstResponder()
        adresTextField?.resignFirstResponder()
        commentInOrderTextField?.resignFirstResponder()
    }
    
    func createStepperButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.backgroundColor = .backElement
        button.setImage(image, for: .normal)
        return button
    }
    
}
 
extension CartView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            phone = phoneTextField?.text ?? ""
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == adresTextField {
            hideKeyboard()
            delegate?.showAdresVC()
            return false
        }
        if textField == phoneTextField {
            if phoneTextField?.text?.isEmpty ?? true {
                phoneTextField?.text = "+7"
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == commentInOrderTextField {
            commentInOrderTextField?.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            return newString.count <= 12
        }
        return true
    }
}


extension CartView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        let array = orderArr[indexPath.row]

        
        let imageView: UIImageView = {
            let image = array.2
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            return imageView
        }()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerY.equalToSuperview().offset(2)
            make.left.equalToSuperview().inset(10)

        }
        
        let labelName: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .regular)
            label.textColor = .black
            label.text = array.0
            label.numberOfLines = 0
            return label
        }()
        cell.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.width.equalTo(150)
        }
        
        let customStepper: UIView = {
            let view = UIView()
            view.backgroundColor = .backElement
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            return view
        }()
        cell.addSubview(customStepper)
        customStepper.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(103)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        let minusButton = createStepperButton(image: .minus)
        minusButton.addTarget(self, action: #selector(stepperMinus(button:)), for: .touchUpInside)
        minusButton.tag = indexPath.row
        customStepper.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(10)
        }
        
        let plusButton = createStepperButton(image: .plus)
        plusButton.addTarget(self, action: #selector(stepperPlus(button:)), for: .touchUpInside)
        plusButton.tag = indexPath.row
        customStepper.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(10)
        }
        
        countLabel = {
            let label = UILabel()
            label.textColor = .black
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.text = String(array.1)
            return label
        }()
        customStepper.addSubview(countLabel ?? UILabel())
        countLabel?.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        
        let symmLabel: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
            label.font = .systemFont(ofSize: 16, weight: .regular)
            let price = array.1 * array.3
            label.text = "\(price) ₽"
            return label
        }()
        cell.addSubview(symmLabel)
        symmLabel.snp.makeConstraints { make in
            make.left.equalTo(labelName.snp.left)
            make.bottom.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
}
