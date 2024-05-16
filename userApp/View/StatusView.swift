//
//  StatusView.swift
//  userApp
//
//  Created by Владимир Кацап on 16.05.2024.
//

import UIKit

class StatusView: UIView {

    var timeLabel: UILabel?
    var statusLabel: UILabel?
    var timerLabel: Timer?
    var timerStatus: Timer?
    var timeOrder = ""
    var callButton: UIButton?
    var stackView: UIStackView?
    var startCookingOrderView, middleCoocingView, finishCookingView: UIView?
    weak var delegate: MainViewControllerDelegate?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createElement()
        timerLabel = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fullTime), userInfo: nil, repeats: true)
        timerStatus = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(seeStatus), userInfo: nil, repeats: true)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createElement() {
        backgroundColor = .black
        
        
        
        timeLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 36, weight: .bold)
            label.textColor = .white
            label.textAlignment = .left
            return label
        }()
        addSubview(timeLabel ?? UIView())
        timeLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(200)
        })
        
        callButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.layer.cornerRadius = 22.5
            button.setImage(.phone, for: .normal)
            button.tintColor = .white
            return button
        }()
        addSubview(callButton ?? UIView())
        callButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(45)
            make.right.top.equalToSuperview().inset(15)
        })
        
        startCookingOrderView = createView()
        startCookingOrderView?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
        middleCoocingView = createView()
        finishCookingView = createView()
        
        
        stackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually

            stack.spacing = 20
            return stack
        }()
        addSubview(stackView ?? UIView())
        stackView?.snp.makeConstraints({ make in
            make.height.equalTo(5)
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview().offset(7)
        })
        
        stackView?.addArrangedSubview(startCookingOrderView ?? UIView())
        stackView?.addArrangedSubview(middleCoocingView ?? UIView())
        stackView?.addArrangedSubview(finishCookingView ?? UIView())
        
        statusLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            label.textAlignment = .left
            label.numberOfLines = 2
            label.text = orderID["message"] as? String
            return label
        }()
        addSubview(statusLabel ?? UILabel())
        statusLabel?.snp.makeConstraints({ make in
            make.right.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(5)
            make.top.equalTo((stackView ?? UIView()).snp.bottom).inset(-5)
        })
        
    }
    

    
    @objc func fullTime() {
        if let orderDate = orderID["date"] as? Date {
            let now = Date()
            let elapsed = now.timeIntervalSince(orderDate)
            let hours = Int(elapsed) / 3600
            let mins = Int(elapsed) / 60 % 60
            let secs = Int(elapsed) % 60
            
            UIView.transition(with: timeLabel!,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                if hours == 0 {
                    self?.timeLabel?.text = String(format: "%02i:%02i", mins, secs )
                } else {
                    self?.timeLabel?.text = String(format: "%02i:%02i:%02i", hours, mins, secs )
                }
            },
                              completion: nil)
        }
    }
    
    func createView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor(red: 51/255, green: 61/255, blue: 73/255, alpha: 1)
        return view
    }
    
    @objc func seeStatus() {
        print(orderID["message"])
        getStatusOrder(orderId: orderID["orderId"] as? Int ?? 1, completion: {
            if let message = orderID["message"] as? String {
                let words = message.split(separator: " ")
                if orderID["message"] as! String != "Начинаем готовить Ваш заказ..." && words.first != "Встречайте" {
                    self.middleCoocingView?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
                    self.statusLabel?.text = orderID["message"] as? String
                }
                if words.first == "Встречайте" {
                    self.finishCookingView?.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
                }
                if orderID["message"] as! String == "Заказ завершен" || orderID["message"] as! String == "Заказ отменен" {
                    self.delegate?.hideStatus()
                }
                
            }
        })
    }
    
    
}
