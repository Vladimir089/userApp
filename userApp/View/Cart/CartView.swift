//
//  CartView.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit

class CartView: UIView {
    
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
    
    var countOrderLabel, summCountOrderLabel, deliveryOrderLabel, summLabel: UILabel?
    var deliveryLabel, itogLabel: UILabel?
    var createOrderButton: UIButton?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createInterface()
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
        backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(gesture)
        
        topView = {
            let view = UIView()
            view.backgroundColor = .backElement
            view.layer.cornerRadius = 10
            return view
        }()
        addSubview(topView ?? UIView())
        
        phoneTextField = {
            let textField = UITextField()
            textField.backgroundColor = .clear
            textField.textAlignment = .right
            textField.keyboardType = .phonePad
            let leftLabel = UILabel()
            leftLabel.text = "Номер телефона "
            leftLabel.textColor = .black
            textField.layer.cornerRadius = 5
            leftLabel.font = .systemFont(ofSize: 18, weight: .regular)
            textField.leftView = leftLabel
            textField.leftViewMode = .always
            textField.delegate = self
            textField.text = phone
            textField.placeholder = "+79222524965"
            return textField
        }()
        topView?.addSubview(phoneTextField ?? UITextField())
        
        separatorView = {
            let view = UIView()
            view.backgroundColor = .separator
            return view
        }()
        topView?.addSubview(separatorView ?? UIView())
        
        adresTextField = {
            let textField = UITextField()
            textField.backgroundColor = .clear
            textField.textAlignment = .right
            textField.layer.cornerRadius = 5
            let leftLabel = UILabel()
            leftLabel.text = "Адрес "
            leftLabel.textColor = .black
            textField.delegate = self
            leftLabel.font = .systemFont(ofSize: 18, weight: .regular)
            textField.leftView = leftLabel
            textField.leftViewMode = .always
            textField.text = adress
            textField.placeholder = "Кошевого, 14, Учкекен"
            return textField
        }()
        topView?.addSubview(adresTextField ?? UITextField())
        
        addSubview(scrollView )
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(contentView)
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.isScrollEnabled = false
            collection.delegate = self
            collection.dataSource = self
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        scrollView.addSubview(collectionView ?? UICollectionView())
        
        if !orderArr.isEmpty {
            let countText = createOrderCountLabelText(count: orderArr.count)
            countOrderLabel = createLabel(text: countText, color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(countOrderLabel ?? UILabel())
            
            var summ = 0
            for i in orderArr {
                summ += (i.1 * i.3)
            }
            summCountOrderLabel = createLabel(text: "\(summ) ₽", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(summCountOrderLabel ?? UILabel())
            
            deliveryLabel = createLabel(text: "Доставка", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(deliveryLabel ?? UILabel())
            
            deliveryOrderLabel = createLabel(text: "\(adressCoast) ₽", color: UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1), font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(deliveryOrderLabel ?? UILabel())
            
            botSeparatorView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
                return view
            }()
            contentView.addSubview(botSeparatorView ?? UIView())
            
            itogLabel = createLabel(text: "Итого", color: .black, font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(itogLabel ?? UILabel())
            
            summLabel = createLabel(text: "\(totalCoast) ₽", color: .black, font: .systemFont(ofSize: 17, weight: .regular))
            contentView.addSubview(summLabel ?? UILabel())
            
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
            view.backgroundColor = .backElement
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
        
        topView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(30)
            make.height.equalTo(100)
        })
        
        phoneTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        })
        
        separatorView?.snp.makeConstraints({ make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        })
        
        adresTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        })
        
        scrollView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo((topView ?? UIView()).snp.bottom).inset(-15)
        })
        
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(scrollView.frame.height + CGFloat(orderArr.count * 110))
        })
        
        collectionView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(orderArr.count * 100)
            make.top.equalToSuperview()
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
                make.left.right.equalTo((collectionView ?? UICollectionView()))
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
    
    @objc func createOrder() {
        
        if phoneTextField?.text?.count ?? 0 < 11 {
            self.errorLabel?.text = "Неверный номер телефона 😢"
            UIView.animate(withDuration: 0.1) {
                self.errorLabel?.alpha = 100
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.errorLabel?.alpha = 0
                }
            }

            return
        }
        
        if adresTextField?.text == "" || adresTextField?.text == " " || adresTextField?.text == nil {
            errorLabel?.text = "Неверный адрес 😢"
            UIView.animate(withDuration: 0.1) {
                self.errorLabel?.alpha = 100
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.errorLabel?.alpha = 0
                }
            }

            return
        }
        
        var menu = ""
        let lastIndex = orderArr.last?.0

        for (index, key, _, _) in orderArr {
            let count = key
            menu.append("\(index) - \(key)")
            if index != lastIndex {
                menu.append(", ")
            }
        }
        delegate?.createNewOrder(phonee: phone, menuItems: menu, clientsNumber: 1, adress: adress, totalCost: totalCoast, paymentMethod: "Наличка", timeOrder: "1", cafeID: 2, completion: { success in
            if success {
                UIView.animate(withDuration: 0.5) { [self] in
                    createOrderButton?.setTitle("Заказ успешно создан!", for: .normal)
                    createOrderButton?.backgroundColor = .systemGreen
                    createOrderButton?.isUserInteractionEnabled = false
                    orderArr.removeAll()
                }
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
                make.height.equalTo(250 + CGFloat(orderArr.count * 110))
            })
            collectionView?.snp.updateConstraints({ make in
                make.height.equalTo(orderArr.count * 110)
            })
            self.layoutIfNeeded()
        }
    }

    
    @objc func stepperMinus(button: UIButton) {
        delegate?.stepperPlusMinus(method: .minus, index: button.tag)
    }
    
    @objc func stepperPlus(button: UIButton) {
        delegate?.stepperPlusMinus(method: .plus, index: button.tag)
    }
    
    @objc func hideKeyboard() {
        phoneTextField?.resignFirstResponder()
        adresTextField?.resignFirstResponder()
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
            make.height.width.equalTo(90)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
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
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
            make.centerY.equalTo(customStepper.snp.centerY)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}
