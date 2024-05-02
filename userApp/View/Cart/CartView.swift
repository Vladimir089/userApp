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
    weak var delegate: CartViewControllerDelegate?

    override init(frame: CGRect) {
        super .init(frame: frame)
        createInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            leftLabel.font = .systemFont(ofSize: 18, weight: .regular)
            textField.leftView = leftLabel
            textField.leftViewMode = .always
            textField.delegate = self
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
            let leftLabel = UILabel()
            leftLabel.text = "Адрес "
            leftLabel.textColor = .black
            textField.delegate = self
            leftLabel.font = .systemFont(ofSize: 18, weight: .regular)
            textField.leftView = leftLabel
            textField.leftViewMode = .always
            textField.placeholder = "Кошевого, 14, Учкекен"
            return textField
        }()
        topView?.addSubview(adresTextField ?? UITextField())
        
        createContraints()
    }
    
    func createContraints() {
        
        topView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
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
        
    }
    
  
    
    @objc func hideKeyboard() {
        phoneTextField?.resignFirstResponder()
        adresTextField?.resignFirstResponder()
    }
}
 
extension CartView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == adresTextField {
            hideKeyboard()
            delegate?.showAdresVC()
            return false
        }
        return true
    }
}
