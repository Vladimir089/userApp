//
//  AdresViewController.swift
//  userApp
//
//  Created by Владимир Кацап on 02.05.2024.
//

import UIKit

class AdresViewController: UIViewController {
    
    var closeView: UIView?
    var adressTextField: UITextField?
    var closeButton: UIButton?
    var adress = ""
    var adressArr = [String]()
    var tableView: UITableView?
    weak var delegate: CartViewControllerDelegate?

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
        
        adressTextField = {
            let textField = UITextField()
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.leftViewMode = .always
            textField.rightViewMode = .whileEditing
            textField.textColor = .black
            textField.text = adress
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 10
            textField.placeholder = "Поиск"
            textField.delegate = self
            return textField
        }()
        view.addSubview(adressTextField ?? UITextField())
        
        closeButton = {
            let button = UIButton(type: .system)
            button.setTitle("Готово", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(closeBut), for: .touchUpInside)
            return button
        }()
        view.addSubview(closeButton ?? UIButton())
        
        tableView = {
            let table = UITableView()
            table.backgroundColor = .white
            table.dataSource = self
            table.isUserInteractionEnabled = true
            table.delegate = self
            table.register(UITableViewCell.self, forCellReuseIdentifier: "1")
            return table
        }()
        view.addSubview(tableView ?? UITableView())
        
        createContraints()
    }

    func createContraints() {
        
        closeView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(4)
        })
        
        adressTextField?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(80)
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(44)
        })
        adressTextField?.becomeFirstResponder()
        
        closeButton?.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.left.equalTo((adressTextField ?? UITextField()).snp.right).inset(-5)
            make.top.equalTo((adressTextField ?? UITextField()).snp.top)
        }
        
        tableView?.snp.makeConstraints({ make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo((adressTextField ?? UITextField()).snp.bottom).inset(-5)
        })
    }
    
    @objc func closeBut() {
        adressTextField?.resignFirstResponder()
        delegate?.closeVC(text: adressTextField?.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cellTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? UITableViewCell else {
            return
        }
        let indexPath = IndexPath(row: cell.tag, section: 0)
        adress = adressArr[indexPath.row]
        adressTextField?.text = adressArr[indexPath.row]
        delegate?.closeVC(text: adress)
        dismiss(animated: true)
    }
    
}

//СДЕЛАТЬ МЕТОД ПОЛУЧЕНИЯ ЦЕНЫ 

extension AdresViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        adressTextField?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        let text = adressTextField?.text ?? ""
        print(text)
        delegate?.closeVC(text: text)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        reload(address: text, controller: self)
    }
}

extension AdresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adressArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = adressArr[indexPath.row]
        label.textColor = .black
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 185/255, green: 185/255, blue: 187/255, alpha: 1)
        cell.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
        cell.tag = indexPath.row
        return cell
    }
    
    
}