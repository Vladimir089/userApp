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
    weak var delegate: CartViewControllerDelegate?
    
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
        
        scrollView.backgroundColor = .gray
        addSubview(scrollView )
        
        contentView.backgroundColor = .brown
        scrollView.addSubview(contentView)
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .red
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        scrollView.addSubview(collectionView ?? UICollectionView())
        
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
        
        let view = UIView()
        view.backgroundColor = .blue
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo((collectionView ?? UICollectionView()).snp.bottom).inset(-110)
            make.height.equalTo(200)
            make.left.right.equalToSuperview().inset(30)
        }
       

    }
    
    func settingsScroll() {
        contentView.isUserInteractionEnabled = true
        contentView.snp.updateConstraints({ make in
            make.height.equalTo(scrollView.frame.height + CGFloat(orderArr.count * 110))
        })
        collectionView?.snp.updateConstraints({ make in
            make.height.equalTo(orderArr.count * 100)
        })
    }
    
    
    
    @objc func hideKeyboard() {
        phoneTextField?.resignFirstResponder()
        adresTextField?.resignFirstResponder()
    }
    
    @objc func sss() {
        print(1)
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


extension CartView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}
