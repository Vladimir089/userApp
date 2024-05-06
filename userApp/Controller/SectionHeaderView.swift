//
//  SectionHeaderView.swift
//  userApp
//
//  Created by Владимир Кацап on 06.05.2024.
//

import Foundation
import UIKit


class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let separatorView: UIView = {
        let view = UIView()
        let dashPattern: [NSNumber] = [12, 12]
        let dashWidth: CGFloat = 1
        let dashColor: UIColor = .backElement
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 500, y: 0)) // ширина линии

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = dashWidth
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.path = path.cgPath

        view.layer.addSublayer(shapeLayer)

        return view
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).inset(-10)
            make.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
