//
//  StatusView.swift
//  userApp
//
//  Created by Владимир Кацап on 16.05.2024.
//

import UIKit

class StatusView: UIView {
    
    var shouldKeepRunning = true
    var timeLabel: UILabel?
    var statusLabel: UILabel?
    var timerLabel: Timer?
    var timerStatus: Timer?
    var timeOrder = ""
    var callButton: UIButton?
    var stackView: UIStackView?
    var startCookingOrderView, middleCoocingView, finishCookingView: UIView?
    weak var delegate: MainViewControllerDelegate?
    var viewsArray: [UIView] = []
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createElement()
        seeStatus()
        DispatchQueue.global().async { [weak self] in
            self?.timerLabel = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                DispatchQueue.main.async {
                    self?.fullTime()
                }
                if !(self?.shouldKeepRunning ?? false) {
                    CFRunLoopStop(CFRunLoopGetCurrent())
                }
            }
            RunLoop.current.run()
        }
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
            button.addTarget(self, action: #selector(callToCafe), for: .touchUpInside)
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
            return label
        }()
        addSubview(statusLabel ?? UILabel())
        statusLabel?.snp.makeConstraints({ make in
            make.right.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(5)
            make.top.equalTo((stackView ?? UIView()).snp.bottom).inset(-5)
        })
       
    }
    
    func changeBackground(view: UIView) {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
            view.alpha = 0.65
        }, completion: { _ in
            view.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5) {
            view.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            
        }
    }
    
    @objc func callToCafe() {
        let phoneNumber = "+79283550302"
        guard let callURL = URL(string: "tel://\(phoneNumber)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(callURL) {
            UIApplication.shared.open(callURL, options: [:], completionHandler: nil)
        } else {
            print("Не удалось совершить звонок")
        }
    }
    
    @objc func fullTime() {
        if let orderDate = orderID["date"] as? Date {
            let now = Date()
            let elapsed = now.timeIntervalSince(orderDate)
            let hours = Int(elapsed) / 3600
            let mins = Int(elapsed) / 60 % 60
            let secs = Int(elapsed) % 60
            
            DispatchQueue.main.async { [weak self] in
                if hours == 0 {
                    self?.timeLabel?.text = String(format: "%02i:%02i", mins, secs )
                } else {
                    self?.timeLabel?.text = String(format: "%02i:%02i:%02i", hours, mins, secs )
                }
            }
            
            
        }
    }
    
    func createView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor(red: 51/255, green: 61/255, blue: 73/255, alpha: 1)
        return view
    }
    
    @objc func seeStatus() {
        
        getStatusOrder(orderId: orderID["orderId"] as? Int ?? 1, completion: {
            
            if orderID["message"] as! String == "Начинаем готовить Ваш заказ..." {
                self.statusLabel?.text = "Начинаем готовить Ваш заказ..."
                if !self.viewsArray.contains(self.startCookingOrderView ?? UIView()) {
                    self.viewsArray.append(self.startCookingOrderView ?? UIView())
                    self.changeBackground(view: self.startCookingOrderView ?? UIView())
                }
                
            }
            
            if orderID["message"] as! String == "В исполнении" {
                self.statusLabel?.text = "Передаём заказ курьеру..."
                if !self.viewsArray.contains(self.middleCoocingView ?? UIView()) {
                    self.viewsArray.append(self.middleCoocingView ?? UIView())
                    self.startCookingOrderView?.layer.removeAllAnimations()
                    self.changeBackground(view: self.middleCoocingView ?? UIView())
                }
                
            }
            
            if orderID["message"] as! String != "В исполнении" && orderID["message"] as! String != "Начинаем готовить Ваш заказ..." {
                self.statusLabel?.text = orderID["message"] as? String
                if !self.viewsArray.contains(self.finishCookingView ?? UIView()) {
                    self.viewsArray.append(self.finishCookingView ?? UIView())
                    self.middleCoocingView?.layer.removeAllAnimations()
                    self.middleCoocingView?.alpha = 1
                    self.changeBackground(view: self.finishCookingView ?? UIView())
                }
                
            }
            
            if orderID["message"] as! String == "Заказ выполнен" || orderID["message"] as! String == "Заказ отменен" {
                self.delegate?.hideStatus()
            }
        })
    }
    
    
}
